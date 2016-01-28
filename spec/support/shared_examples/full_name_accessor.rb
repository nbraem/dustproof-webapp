shared_examples "an Object with a full_name accessor" do
  let(:class_name) { described_class.to_s.underscore }

  describe "#full_name" do
    it "returns the concatenated first_name and last_name if they are set" do
      # setup
      current_object = build(class_name)

      # excercise and verify
      expect(current_object.full_name).to eq "#{current_object.first_name} #{current_object.last_name}"
    end

    it "returns only the set name" do
      # setup
      current_object = build(class_name, last_name: nil)

      # excercise and verify
      expect(current_object.full_name).to eq "#{current_object.first_name}"
    end

    it "returns nil if no name is set" do
      # setup
      current_object = build(class_name, first_name: nil, last_name: nil)

      # excercise and verify
      expect(current_object.full_name).to be nil
    end
  end
end
