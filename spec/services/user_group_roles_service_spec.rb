require 'rails_helper'

RSpec.describe UserGroupRolesService do
  describe '.call' do
    let(:user) { instance_double('User') }

    context 'when user role is "agency_with_refund" and context is :invite' do
      before do
        allow(user).to receive(:role).and_return("agency_with_refund")
      end

      it 'returns ["data_agent"]' do
        expect(described_class.call(user, context: :invite)).to eq(["data_agent"])
      end
    end

    context 'when user role is "cbd_user"' do
      before do
        allow(user).to receive(:role).and_return("cbd_user")
      end

      it 'returns ["data_agent"]' do
        expect(described_class.call(user)).to eq(["data_agent"]) # context does not matter here
      end
    end

    context 'when user is in agency group' do
      before do
        allow(user).to receive(:role).and_return("some_other_role")
        allow(user).to receive(:in_agency_group?).and_return(true)
      end

      it 'returns AGENCY_ROLES' do
        expect(described_class.call(user)).to eq(User::AGENCY_ROLES) # context does not matter here
      end
    end

    context 'when user is in finance group' do
      before do
        allow(user).to receive(:role).and_return("some_other_role")
        allow(user).to receive(:in_agency_group?).and_return(false)
        allow(user).to receive(:in_finance_group?).and_return(true)
      end

      it 'returns FINANCE_ROLES' do
        expect(described_class.call(user)).to eq(User::FINANCE_ROLES) # context does not matter here
      end
    end

    context 'when user does not fit any predefined group' do
      before do
        allow(user).to receive(:role).and_return("some_other_role")
        allow(user).to receive(:in_agency_group?).and_return(false)
        allow(user).to receive(:in_finance_group?).and_return(false)
      end

      it 'returns an empty array' do
        expect(described_class.call(user)).to eq([]) # context does not matter here
      end
    end
  end
end
