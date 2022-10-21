# frozen_string_literal: true

namespace :summary_stats do
  desc "Generate simple summary stats for use in quarterly DEFRA reports"

  task :stats_for_date_range, [:start_date, :end_date] => :environment do |_t, args|

    include ActionView::Helpers::NumberHelper

    unless args[:start_date].present? && args[:end_date].present?
      puts "Usage, with date format YYYY-MM-DD: rake summary_stats[start_date,end_date]"
      exit
    end

    start_date = Date.parse(args[:start_date])
    end_date = Date.parse(args[:end_date])

    puts "======================================================================================================================================="

    abandon_rate = calcs_for_abandon_rate
    calcs_for_date_range(start_date, end_date, abandon_rate)
  end

  def calcs_for_abandon_rate
    # we only have transient_registration data for the last 30 days. Use these to estimate the abandon rate.

    puts "Calculations:"

    transient_30d = WasteCarriersEngine::TransientRegistration.where(created_at: {"$gte" => 30.days.ago}).count
    puts "\tTransient registrations created in the last 30 days: #{transient_30d}"

    activated_30d = WasteCarriersEngine::Registration.where('metaData.dateActivated': { "$gte" => 30.days.ago }).count
    puts "\tRegistrations activated in the last 30 days: #{activated_30d}"

    started_30d = transient_30d + activated_30d
    puts "\tSo total registrations started in the last 30 days ~ #{transient_30d} + #{activated_30d} = #{started_30d}"

    abandoned_30d = transient_30d.to_f / started_30d.to_f
    puts "\tSo approximate abandon rate = #{transient_30d} / #{started_30d} = #{number_to_percentage(100.0 * abandoned_30d, precision: 0)}"

    abandoned_30d
  end

  def calcs_for_date_range(start_date, end_date, abandon_rate)
    puts "\tFrom #{start_date} to #{end_date} inclusive:"

    orders_activated = WasteCarriersEngine::Registration.collection.aggregate(
      [
        { "$match": { 'metaData.dateActivated': { "$gte" => start_date, "$lte" => end_date } } },
        { "$project": { order: "$financeDetails.orders" } },
        { "$unwind": "$order" },
        { "$group": { _id: 0, order_count: { "$sum": 1 } } }
      ]).first["order_count"]
    orders_activated_s = number_with_delimiter(orders_activated)
    puts "\tTotal orders activated: #{orders_activated}, of which:"

    assisted_digital_orders = WasteCarriersEngine::Registration.collection.aggregate(
      [
        { "$match": { 'metaData.dateActivated': { "$gte" => start_date, "$lte" => end_date }, 'metaData.route': 'ASSISTED_DIGITAL' } },
        { "$project": { order: "$financeDetails.orders" } },
        { "$unwind": "$order" },
        { "$group": { _id: 0, order_count: { "$sum": 1 } } }
      ]).first["order_count"]
    assisted_digital_orders_s = number_with_delimiter(assisted_digital_orders)
    puts "\t... assisted digital: #{assisted_digital_orders_s}"

    # We could just subtract assisted_digital_orders from orders_activated, but in some cases metaData.route is not populated so this is safer:
		fully_digital_orders = WasteCarriersEngine::Registration.collection.aggregate(
      [
        { "$match": { 'metaData.dateActivated': { "$gte" => start_date, "$lte" => end_date }, 'metaData.route': 'DIGITAL' } },
        { "$project": { order: "$financeDetails.orders" } },
        { "$unwind": "$order" },
        { "$group": { _id: 0, order_count: { "$sum": 1 } } }
      ]).first["order_count"]
    fully_digital_orders_s = number_with_delimiter(fully_digital_orders)
    puts "\t... fully digital: #{fully_digital_orders}"

    delta = orders_activated - assisted_digital_orders - fully_digital_orders
    puts "\t(delta of #{delta} is due to some registrations not having metaData.route set)" unless delta.zero?

    abandon_rate_s = number_to_percentage(100.0 * abandon_rate, precision: 0)
    non_abandon_rate_s = number_to_percentage(100.0 * (1 - abandon_rate), precision: 0)

    total_orders_started = (orders_activated / (1.0 - abandon_rate)).round(0)
    total_orders_started_s = number_with_delimiter(total_orders_started.to_i)

    total_orders_completed = fully_digital_orders + assisted_digital_orders + delta
    total_orders_completed_s = number_with_delimiter(total_orders_completed)

    total_orders_started_online = (fully_digital_orders / (1.0 - abandon_rate)).round(0)
    total_orders_started_online_s = number_with_delimiter(total_orders_started_online)

    total_orders_abandoned = total_orders_started - total_orders_completed
    total_orders_abandoned_s = number_with_delimiter(total_orders_abandoned)

    puts "\tSo including abandoned attempts, estimated orders started = " \
         "#{orders_activated_s} / (1 - #{abandon_rate_s}) = #{total_orders_started_s}, of which: "
    puts "\t... completed: #{total_orders_completed_s}"
    puts "\t... abandoned: #{total_orders_abandoned_s}"

    puts "\nSummary:"
    puts "\t1. Total number of transactions started and completed online only: #{fully_digital_orders_s}"
    puts "\t2. Total number of transactions started online: ESTIMATED: #{total_orders_started_online_s}"
    puts "\t\t(Estimated dropoff rate for the last 30 days: #{abandon_rate_s}"
    puts "\t\t so estimated completion (non-abandoned) rate for the last 30 days: #{non_abandon_rate_s}"
    puts "\t\t so given #{fully_digital_orders_s} fully digital orders, estimated total orders started online = " \
         "(#{fully_digital_orders_s}/#{non_abandon_rate_s}) = #{total_orders_started_online_s})"
    puts "\t3. Number of online claims: #{fully_digital_orders_s}"
    puts "\t4. Total number of claims (online + offline + uknown): " \
         "#{fully_digital_orders_s} + #{assisted_digital_orders_s} + #{delta} = #{total_orders_completed_s}"

    puts "======================================================================================================================================="
  end
end
