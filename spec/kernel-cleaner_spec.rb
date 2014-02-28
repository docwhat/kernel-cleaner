require 'spec_helper'

describe App do
  subject(:app) { described_class.new }

  describe 'trim_version' do
    [
      ['1.2.3', '1.2.3'],
      ['1.2.3-45.67', '1.2.3-45']
    ].each do |input, output|
      context "given #{input}" do
        it "returns #{output}" do
          expect(app.trim_version(input))
            .to eq(output)
        end
      end
    end
  end

  describe 'installed_packages' do
    it 'has multiple 57 items' do
      expect(app.installed_packages.keys)
        .to include('3.2.0-36')
      expect(app.installed_packages['3.2.0-36'])
        .to have_exactly(3).items
    end
    it 'only includes kernel related packages' do
      app.installed_packages.values.flatten.each do |pkg|
        expect(pkg).to match(/^linux-(image|headers)-\d/)
      end
    end
  end

  its(:current_version) { should eq('3.2.0-57') }
  its(:latest_version) { should eq('3.2.0-59') }
  its(:emergency_version) { should eq('3.2.0-58') }

  describe 'obsolete_packages' do
    it "doesn't include the current" do
      app.installed_packages[app.current_version].each do |pkg|
        expect(app.obsolete_packages)
          .to_not include(pkg)
      end
    end

    it "doesn't include the latest" do
      app.installed_packages[app.latest_version].each do |pkg|
        expect(app.obsolete_packages)
          .to_not include(pkg)
      end
    end

    it "doesn't include the emergency" do
      app.installed_packages[app.emergency_version].each do |pkg|
        expect(app.obsolete_packages)
          .to_not include(pkg)
      end
    end
  end
end
