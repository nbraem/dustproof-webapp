require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "icon_text" do
    it "provides an icon with text" do
      expect(helper.icon_text("gear", "Gear icon with text")).to eq("<i class=\"fa fa-gear\"></i> Gear icon with text")
    end

    it "provides an icon without text" do
      expect(helper.icon_text("gear")).to eq("<i class=\"fa fa-gear\"></i>")
    end
  end
end
