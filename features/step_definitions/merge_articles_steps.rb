Given /^the following (.*?) exist:$/ do |type, table|
  table.hashes.each do |table_item|
    if    type == "users"    then User.create(table_item)
    elsif type == "articles" then Article.create(table_item)
    elsif type == "comments" then Comment.create(table_item)
    end
  end 
end

Given /^I am logged in as an? (.*) user$/ do |role|
  visit '/accounts/login'
  case role
    when "admin" then
      fill_in 'user_login', :with => 'admin'
      fill_in 'user_password', :with => 'aaaaaaaa'
    when "non-admin" then
      fill_in 'user_login', :with => 'user_1'
      fill_in 'user_password', :with => '1234567' 
  end
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end   
end

When /^I merge two articles$/ do
  steps %{
    And I am on the Edit page for Article with id 3
    When I fill in "merge_with" with "4"
    And I press "Merge"
  }
end

Then /^there should be a merged article$/ do
  return false unless Article.find(3)
end

Then /^the duplicate article should be deleted$/ do
  count = Article.find(:all).count
  steps %{
    Given I am logged in as an admin user
    When I merge two articles
  }
  new_count = Article.find(:all).count
  assert new_count == count - 1
end

Then /^the merged article contains body text of both original source articles$/ do
  merged_article = Article.find(3).body
  if merged_article.respond_to? :should
    merged_article.should have_content('Content1')
    merged_article.should have_content('Content2')
  else
    assert merged_article.should have_content('Content1')
    assert merged_article.should have_content('Content2')
  end 
end

Then /^the merged article has same author as either of the original source articles$/ do
  merged_article = Article.find(3).author
  if merged_article.respond_to? :should
    merged_article.should have_content('user_1' || 'user_2')
  else
    assert merged_article.should have_content('user_1' || 'user_2')
  end
end

Then /^the merged article has carried across comments from both original source articles$/ do
  merged_comments_count = Comment.find_all_by_article_id(3).count
  if merged_comments_count.respond_to? :should
    merged_comments_count.should eq(4)
  else
    assert merged_comments_count.should eq(4)
  end
end
