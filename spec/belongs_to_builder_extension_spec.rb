require 'rails_helper'

RSpec.describe RailsPolymorphicSelect::BelongsToBuilderExtension do
  let(:zebra){ create(:animal, name: 'Zebra', scientific_name: 'Equus zebra') }
  let(:cheetah){ create(:animal, eats: zebra)}

  it 'creates a global id reader method for polymorphic belongs to relationships' do
    expect(Animal.public_method_defined?(:eats_global_id)).to eql(true)
  end

  it 'creates a global id writer method for polymorphic belongs to relationships' do
    expect(Animal.public_method_defined?(:eats_global_id=)).to eql(true)
  end

  it 'does not create a global id reader method for non-polymorphic belongs to relationships' do
    expect(Planet.public_method_defined?(:star_global_id)).to eql(false)
  end

  it 'does not create a global id writer method for non-polymorphic belongs to relationships' do
    expect(Planet.public_method_defined?(:star_global_id=)).to eql(false)
  end

  describe "#*_global_id" do
    it "returns the related item's global id" do
      expect(cheetah.eats_global_id).to eql(zebra.to_global_id)
    end

    it "returns nil if the relationship is not set" do
      expect(zebra.eats_global_id).to be_nil
    end
  end

  describe "#*_global_id=" do
    it "relates the correct record" do
      plant = create(:plant)
      zebra.eats_global_id = plant.to_global_id
      expect(zebra.eats).to eql(plant)
    end

    it "remove the relationship if the value is blank" do
      cheetah.eats_global_id = ""
      expect(cheetah.eats).to be_nil
    end
  end

end
