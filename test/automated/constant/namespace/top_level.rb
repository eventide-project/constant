require_relative "../../automated_init"

context "Constant" do
  context "Namespace" do
    control_value = Controls::Constant.example

    constant = Constant.new(control_value)

    namespace = constant.namespace

    comment "Raw Constant: #{control_value.inspect}"
    comment "Namespace: #{namespace.inspect}"

    test do
      assert(namespace.raw_constant == Object)
    end
  end
end
