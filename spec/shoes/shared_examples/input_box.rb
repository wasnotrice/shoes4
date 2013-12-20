shared_examples "input box" do 
  it "highlights text" do
    subject.gui.should_receive(:highlight_text).with(0, 3)
    subject.highlight_text 0, 3
  end

  it "moves caret" do
    subject.gui.should_receive(:caret_to).with(4)
    subject.caret_to 4
  end
end
