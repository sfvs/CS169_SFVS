# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the "login" page$/ then '/member/sign_in'
    when /^the "profile" page for "(.*)"$/ then "/users/#{User.find_by_email($1).id}"
    when /^the "registration" page$/ then "/member/sign_up"
    when /^the "registration failed" page$/ then "/member"
    when /^the admin profile page$/ then '/admin'
    when /^the admin "(.*)" page$/ then '/admin/' + $1
    when /^the "survey" page for "(.*)"$/ then "/users/#{User.find_by_email($1).id}/survey"
    when /^the creation page for "(.*)"$/ then "/admin/forms/#{Form.find_by_form_name($1).id}/form_questions/new"
    when /^the content page for "(.*)"$/ then "/admin/forms/#{Form.find_by_form_name($1).id}/form_questions"
    when /^the "(.*)" form page for "(.*)"$/ then "/users/#{User.find_by_email($2).id}/form/#{Form.find_by_form_name($1).id}"
    when /^the user content page for "(.*)"$/ then "/admin/users/#{User.find_by_email($1).id}"
    when /^the users list page$/ then "/admin/users"
    when /^the "Application" page for "(.*)"$/ then "/admin/users/#{User.find_by_email($1).id}/applications/1"
    when /^the edit form page for General Form of "(.*)"$/ then  "/admin/users/#{User.find_by_email($1).id}/applications/1/edit_form?form_type=General+Form"

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
