# frozen_string_literal: true

RSpec.describe Aroap do
  after do
    User.delete_all
  end

  it "has a version number" do
    expect(Aroap::VERSION).not_to be nil
  end

  describe "#profile" do
    it "works without errors" do
      Aroap.profile do
        User.create!(name: "willnet")
        User.find_by!(name: "willnet")
      end
    end
  end
end
