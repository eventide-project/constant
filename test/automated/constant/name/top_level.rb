require_relative "../../automated_init"

context "Constant Name" do
  control_value = Controls::Constant.example

  constant = Constant.new(control_value)

  name = constant.name

  comment "Raw Constant: #{control_value.inspect}"
  comment "Name: #{name.inspect}"

  context "Is the whole name as a String" do
    test do
      assert(name == control_value.name)
    end
  end
end
