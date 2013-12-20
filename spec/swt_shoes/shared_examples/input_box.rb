shared_examples "swt input box" do
  it "sets text on real element" do
    subject.real.should_receive(:text=).with("some text")
    subject.text = "some text"
  end

  it "highlights text" do
    subject.real.should_receive(:set_selection).with(0, 3)
    subject.highlight_text 0, 3
  end

  it "moves caret" do
    subject.real.should_receive(:set_selection).with(4)
    subject.caret_to 4
  end
end
