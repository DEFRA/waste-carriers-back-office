# frozen_string_literal: true

RSpec.shared_examples "a user" do |model_name|
  describe "password validations" do
    let(:user) { build(model_name, password: password) }
    let(:password) { "" }

    context "when the user's password meets the requirements" do
      let(:password) { "Secretofth3w0rld" }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the user's password is blank" do
      let(:password) { "" }

      it "is not valid" do
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("You must enter a password")
      end
    end

    context "when the user's password is too short" do
      let(:password) { "Sec1329892" }

      it "is not valid" do
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("The password must be at least 14 characters long")
      end
    end

    it "validates password contains lower case, upper case, and either numeric or special characters" do
      user.password = "passwordonemillion" # only lower case
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("The password must contain uppercase letters, lowercase letters, and numbers or symbols")

      user.password = "PASSWORDONEMILLION" # only upper case
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("The password must contain uppercase letters, lowercase letters, and numbers or symbols")

      user.password = "Password1million" # lower, upper, and numeric
      expect(user).to be_valid

      user.password = "Password!million" # lower, upper, and special
      expect(user).to be_valid
    end

    it "validates password is not a dictionary word" do

      user.password = "dichl0rodiphenyltrichloroethan3" # simple substitution of a common dictionary word
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("The password must not be a single word from the dictionary")

      user.password = "HeartWhole3287£" # not a common dictionary word
      expect(user).to be_valid
    end

    it "validates password does not contain obvious sequences" do
      user.password = "Dichlorodiphenyltrichloroethane123" # contains an obvious sequence
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("The password must not contain an obvious sequence of characters")

      user.password = "Dichlorodiphenyltrichloroethane176" # does not contain any obvious sequence
      expect(user).to be_valid
    end
  end
end
