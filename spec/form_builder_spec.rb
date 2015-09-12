require 'rails_helper'

RSpec.describe RailsPolymorphicSelect::FormBuilder do
  let!(:cheetah){ create(:animal) }
  let!(:zebra){ create(:animal, name: 'Zebra', scientific_name: 'Equus zebra') }
  let!(:plant){ create(:plant) }

  let(:template){ ActionView::Base.new }

  let(:form_builder){ ActionView::Helpers::FormBuilder.new(:animal, cheetah, template, {}) }


  describe '#polymorphic_select' do
    subject { form_builder.polymorphic_select(:eats_global_id, [Animal, Plant]) }

    it "produces the correct markup" do
      expect(subject).to have_tag('select', with: {name: 'animal[eats_global_id]'}) do
        with_tag('optgroup', with: {label: 'Animal'}) do
          with_tag('option', with: {value: cheetah.to_global_id}, text: cheetah.name)
          with_tag('option', with: {value: zebra.to_global_id}, text: "Zebra")
        end
        with_tag('optgroup', with: {label: 'Plant'}) do
          with_tag('option', with: {value: plant.to_global_id}, text: plant.name)
        end
      end
    end

    it "has no selected option if there is no resource selected yet" do
      expect(subject).to_not have_tag('option', with: {selected: 'selected'})
    end

    describe 'explicitly setting the label method' do
      subject { form_builder.polymorphic_select(:eats_global_id, [Animal, Plant], label_method: :scientific_name) }

      it "produces the correct markup" do
        expect(subject).to have_tag('select', with: {name: 'animal[eats_global_id]'}) do
          with_tag('optgroup', with: {label: 'Animal'}) do
            with_tag('option', with: {value: cheetah.to_global_id}, text: cheetah.scientific_name)
            with_tag('option', with: {value: zebra.to_global_id}, text: "Equus zebra")
          end
          with_tag('optgroup', with: {label: 'Plant'}) do
            with_tag('option', with: {value: plant.to_global_id}, text: plant.scientific_name)
          end
        end
      end
    end

    describe 'using a #to_label method to override the autoguess of name' do
      before do
        Animal.send(:define_method, :to_label) do
          scientific_name
        end
      end

      it "produces the correct markup" do
        expect(subject).to have_tag('select', with: {name: 'animal[eats_global_id]'}) do
          with_tag('optgroup', with: {label: 'Animal'}) do
            with_tag('option', with: {value: cheetah.to_global_id}, text: cheetah.scientific_name)
            with_tag('option', with: {value: zebra.to_global_id}, text: "Equus zebra")
          end
          with_tag('optgroup', with: {label: 'Plant'}) do
            with_tag('option', with: {value: plant.to_global_id}, text: plant.name)
          end
        end
      end
    end

    describe 'with an item selected' do
      before do
        cheetah.update_attributes(eats: zebra)
      end

      it "selects the correct item" do
        expect(subject).to have_tag('option', with: {value: zebra.to_global_id, selected: 'selected'})
      end
    end
  end
end
