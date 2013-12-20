require 'swt_shoes/spec_helper'

describe Shoes::Swt::EditLine do
  let(:container) { real }
  let(:gui)    { double("gui", real: real) }
  let(:app)    { double("app", gui: gui) }
  let(:text)   { "Cheese plate" }
  let(:dsl) { double('dsl', app: app,
                     visible?: true,
                     element_width: 80, element_height: 22,
                     initial_text: text,
                     secret?: true).as_null_object }
  let(:parent) { double('parent') }
  let(:real) { double('real', is_disposed?: false, disposed?: false, text: text).as_null_object }

  subject { Shoes::Swt::EditLine.new dsl, parent }

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
    let(:source) { double("source", class: Java::OrgEclipseSwtWidgets::Text) }
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

  describe ":secret option" do
    it "sets PASSWORD style" do
      subject.real.getStyle & (::Swt::SWT::SINGLE | ::Swt::SWT::BORDER | ::Swt::SWT::PASSWORD) == ::Swt::SWT::SINGLE | ::Swt::SWT::BORDER | ::Swt::SWT::PASSWORD
    end
  end
end
