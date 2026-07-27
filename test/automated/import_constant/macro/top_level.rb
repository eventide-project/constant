require_relative "../../automated_init"

context "Import Constant" do
  context "Macro" do
    context "Top Level" do
      control_script = Controls::Script.top_level_import

      error_output = control_script.error

      comment "Error Output: #{error_output.lines.first&.strip.inspect}"

      context "Inclusion at the top level is refused" do
        test do
          assert(error_output.include?("Constant::Import cannot be included at the top level"))
        end
      end

      context "The refinement is named as the remedy" do
        test do
          assert(error_output.include?("using Constant::Import"))
        end
      end
    end
  end
end
