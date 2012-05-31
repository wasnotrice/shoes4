class Shoes::Check
  def check=(flag)
    real.set_selection flag
  end
  def check
    real.get_selection
  end
end

Shoes.app do
  p self
  c = check
  p c.class
  p c.real
  c.check = true
  p c.check
end