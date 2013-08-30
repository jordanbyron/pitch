# Copied from the minitest hook of capybara-screenshot:
# https://github.com/mattheworiordan/capybara-screenshot/blob/master/lib/capybara-screenshot/minitest.rb

FeatureScreenshot = ->(context) {
  # by adding the argument context, MiniTest passes the context of the test
  # which has an instance variable @passed indicating success / failure
  failed = context.instance_variable_get(:@passed).blank?

  if Capybara::Screenshot.autosave_on_failure && failed
    filename_prefix = Capybara::Screenshot.filename_prefix_for(:minitest,
                                                               context)

    saver = Capybara::Screenshot::Saver.new(Capybara, Capybara.page, true,
                                            filename_prefix)
    saver.save
  end
}
