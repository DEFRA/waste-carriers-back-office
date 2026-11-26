# frozen_string_literal: true

namespace :boxi do
  desc "Profile BOXI export. CPU sampling requires Linux."
  task profile: :environment do
    total = WasteCarriersEngine::Registration.count
    puts "Registrations: #{total}"

    cpu_samples = []
    sampling = true

    sampler = Thread.new do
      while sampling && File.exist?("/proc/stat")
        stat1 = File.read("/proc/stat").lines.first.split[1..4].map(&:to_f)
        sleep 1
        stat2 = File.read("/proc/stat").lines.first.split[1..4].map(&:to_f)
        delta = stat2.zip(stat1).map { |a, b| a - b }
        cpu_samples << ((delta.sum - delta[3]) / delta.sum * 100).round(1) if sampling
      end
    end

    Dir.mktmpdir do |dir|
      time = Benchmark.realtime { Reports::GenerateBoxiFilesService.run(dir) }
      sampling = false
      sampler.join(1)

      puts "Time: #{time.round(1)}s"
      puts "CPU:  #{(cpu_samples.sum / cpu_samples.size).round(1)}% avg" if cpu_samples.any?
    end
  end
end
