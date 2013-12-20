require 'swt_shoes/spec_helper'

describe Shoes::Swt::EditBox do
  let(:container) { real }
  let(:gui)    { double("gui", real: real, clickable_elements: [], add_clickable_element: nil) }
  let(:app)    { double("app", gui: gui) }
  let(:text)   { "Cheese plate" }
  let(:real)   { double('real', is_disposed?: false, disposed?: false, text: text).as_null_object }
  let(:parent) { double("parent", gui: gui, real: real, app: app) }
  let(:dsl)    { double('dsl', app: app, visible?: true,
                        element_left: 100, element_top: 100,
                        element_width: 70, element_height: 10,
                        initial_text: text, secret?: false ) }

  subject { Shoes::Swt::EditBox.new dsl, parent }

  before :each do
    parent.stub(:real)
    ::Swt::Widgets::Text.stub(:new) { real }
    ::Swt::Widgets::Text.stub(:text=) { real }
  end

  it_behaves_like "movable element"
  it_behaves_like "clearable native element"
  it_behaves_like "togglable"
  it_behaves_like "swt input box"

  describe "#initialize" do
    it "adds a modify listener" do
      real.should_receive(:add_modify_listener)
      subject
    end
  end

  describe "responding to change" do
    let(:source) { double("source", class: Java::OrgEclipseSwtWidgets::Text, text: text) }
    let(:event) { double("event", source: source, class: Java::OrgEclipseSwtEvents::ModifyEvent) }

    context "when text has changed" do
      it "sets up a listener that delegates change events" do
        source.stub(:text) { "Prime rib" }
        expect(real).to receive(:add_modify_listener) { |&arg| arg.call(event) }
        expect(dsl).to receive(:call_change_listeners)
        subject
      end
    end

    context "when text has NOT changed" do
      it "does not call other change listeners" do
        source.stub(:text) { text }
        expect(real).to receive(:add_modify_listener) { |&arg| arg.call(event) }
        expect(dsl).not_to receive(:call_change_listeners)
        subject
      end
    end
  end
end
