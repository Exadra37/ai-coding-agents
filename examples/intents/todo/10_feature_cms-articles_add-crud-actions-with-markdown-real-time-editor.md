# 10 - Feature (CMS-Articles): Add CRUD actions with Markdown Real-Time Editor

## 1. Why

### 1.1 Objective

Add full CRUD functionality for Articles using the Markdown Real-Time Editor component, enabling authenticated users to create, manage, and prepare content for publishing.

### 1.2 Context

This is a core MVP feature (1.1.3 from README.md) that builds upon the Markdown Real-Time Editor component. Articles are the primary content type users will create and publish to social media platforms. Phoenix 1.8's authentication generates code with Scopes by default, ensuring proper user data isolation.

### 1.3 Depends On Intents

* 6 - Feature (Accounts-Users): Add user authentication
* 7 - Feature (Markdown-RealTimeEditor): Create reusable Markdown editor LiveView component
* 8 - Enhancement (web-layer): Atomize parameters for attributes to call the Domain Resource API

### 1.4 Related to Intents

* Future: Feature (CMS-Articles): Add hashtag support
* Future: Feature (CMS-Publishing): Manual publishing to platforms

## 2.0 What

```gherkin
Feature: CMS Articles - Add CRUD actions with Markdown Real-Time Editor

  As an authenticated user
  I want to create, read, update, and delete my articles
  So that I can manage my content before publishing

  Background:
    Given I am logged in as a user

  Scenario: List my articles
    Given I have created some articles
    When I visit the articles index page
    Then I should see a list of my articles
    And I should see a button to create a new article
    And I should not see articles from other users

  Scenario: Create a new article
    Given I am on the new article page
    When I enter a title "My First Article"
    And I enter markdown content in the left editor panel
    Then I should see the real-time HTML preview in the right panel
    When I click the "Create Article" button
    Then I should see the article view page
    And a success message "Article created successfully"

  Scenario: View my article
    Given I have an article with title "My Article"
    When I visit the article's view page
    Then I should see the article title "My Article"
    And I should see the content rendered as HTML
    And I should see edit and delete buttons

  Scenario: Edit my article
    Given I have an article
    When I visit the article's edit page
    Then I should see the markdown editor with my content in the left panel
    And I should see the real-time preview in the right panel
    When I update the content
    And I click the "Update Article" button
    Then I should see the updated article view page
    And a success message "Article updated successfully"

  Scenario: Delete my article
    Given I have an article
    When I visit the article's view page
    And I click the "Delete" button
    And I confirm the deletion
    Then I should be redirected to the articles index page
    And a success message "Article deleted successfully"

  Scenario: User cannot view another user's article
    Given another user has created an article
    When I try to access that article's URL directly
    Then I should see an error message
    And be redirected to my articles index page

  Scenario: User cannot edit another user's article
    Given another user has created an article
    When I try to access that article's edit URL directly
    Then I should see an error message
    And be redirected to my articles index page

  Scenario: User cannot delete another user's article
    Given another user has created an article
    When I try to delete that article
    Then I should see an error message
    And the article should still exist
```

## 3.0 How

### 3.1 Implementation Context

The Articles CRUD will follow the Domain Resource Action architecture for both web and business logic layers as specified in ARCHITECTURE.md. Phoenix 1.8's phx.gen.live with the authentication system automatically generates code that uses Scopes, ensuring users can only access their own articles. All code will be implemented using TDD first approach with red-green-refactor cycle. The web layer will integrate the Markdown Real-Time Editor component for Create and Edit actions with split-screen layout.

### 3.2 Tasks

* [ ] 1.0 - Generate the CMS Articles CRUD with Phoenix LiveView:
  - [ ] 1.1 - Run `mix phx.gen.live CMS.Articles Article articles title:string content:text --web CMS.Articles`
  - [ ] 1.2 - Run `mix ecto.migrate` to apply the database migration
  - [ ] 1.3 - Add a new `scope "/cms/articles", SocialMediaWeb.CMS.Articles` in `lib/social_media_web/router.ex` that pipes through `:browser` and wraps routes in `live_session :cms_articles_require_authenticated_user` with `on_mount: [{SocialMediaWeb.Accounts.Users.UserAuth, :require_authenticated}]`
  - [ ] 1.4 - Inside the live_session, add all article routes removing the duplicated `articles` from paths (e.g., `/` for index, `/new` for new, `/:id` for show, `/:id/edit` for edit)
  - [ ] 1.5 - Run `mix compile` to find all modules with route warnings
  - [ ] 1.6 - Create a list of files with route warnings from the compile output
  - [ ] 1.7 - Use find-and-replace tool to fix all route references in one pass across all files in the list
  - [ ] 1.8 - Run `mix compile` again to verify no route warnings remain
  - [ ] 1.9 - Run `mix test` to ensure all generated tests pass
* [ ] 2.0 - Refactor Phoenix Context into Domain Resource Action architecture:
  - [ ] 2.1 - Move `lib/social_media/cms/articles.ex` to `lib/social_media/cms/cms_articles_api.ex` and update module name to `SocialMedia.CMS.CmsArticlesApi`
  - [ ] 2.2 - Extract `list_articles/1` into `lib/social_media/cms/articles/list/list_cms_articles.ex` with public function `list/1` that accepts `%Scope{}` and filters by `scope.user.id`
  - [ ] 2.3 - Extract `get_article!/2` into `lib/social_media/cms/articles/get/get_cms_article.ex` with public function `get!/2` that accepts `%Scope{}` and filters by `scope.user.id`
  - [ ] 2.4 - Extract `create_article/2` into `lib/social_media/cms/articles/create/create_cms_article.ex` with public function `create/2` that accepts `%Scope{}` and associates with `scope.user.id`
  - [ ] 2.5 - Extract `update_article/3` into `lib/social_media/cms/articles/update/update_cms_article.ex` with public function `update/3` that accepts `%Scope{}` and verifies article belongs to `scope.user.id`
  - [ ] 2.6 - Extract `delete_article/2` into `lib/social_media/cms/articles/delete/delete_cms_article.ex` with public function `delete/2` that accepts `%Scope{}` and verifies article belongs to `scope.user.id`
  - [ ] 2.7 - Extract `change_article/2` into `lib/social_media/cms/articles/change/change_cms_article.ex` with public function `change/2`
  - [ ] 2.8 - Update all web layer LiveView modules to import and call `CmsArticlesApi`, sanitizing params using `SocialMedia.atomize_params_map/2` with allowed keys `["title", "content"]` before API calls
  - [ ] 2.9 - Rename and update test file from `test/social_media/cms/articles_test.exs` to `test/social_media/cms/cms_articles_api_test.exs`, updating all tests to test the API module and ensure proper user scoping
  - [ ] 2.10 - Run `mix test test/social_media/cms/cms_articles_api_test.exs` to ensure all API tests pass
  - [ ] 2.11 - Extract `broadcast_article/2` into `lib/social_media/cms/articles/broadcast/broadcast_cms_article.ex` with public function `broadcast/2`
* [ ] 3.0 - Integrate Markdown Real-Time Editor in Create form, with the TDD red-green-refactor approach:
  - [ ] 3.1 - Write test in `test/social_media_web/live/cms/articles/article_live_test.exs` for form component using the Markdown Real-Time Editor component
  - [ ] 3.2 - Update form component to integrate Markdown Real-Time Editor component for the content field
  - [ ] 3.3 - Refactored the Markdown RealTime Editor to fix not working when added inside a LiveView with a form, like inside the Articles LiveView form.
* [ ] 4.0 - Update Show page to render Markdown as HTML, with a TDD red-green-refactor approach:
  - [ ] 4.1 - Write test for show page rendering markdown content as HTML using `Mdex.to_html!/1`
  - [ ] 4.2 - Update `show.html.heex` to render content as HTML using `Mdex.to_html!/1`
  - [ ] 4.3 - Add appropriate CSS styling for rendered HTML elements
* [ ] 5.0 - Verify authentication and user scoping in the LiveView tests for Catalogs Products, with the TDD red-green-refactor approach:
  - [ ] 5.1 - Review and update generated LiveView tests in `test/social_media_web/live/cms/articles/article_live_test.exs` to ensure they test user scoping
  - [ ] 5.2 - Add test for index page displaying only current user's articles and not other users' articles
  - [ ] 5.3 - Add test for preventing view of another user's article
  - [ ] 5.4 - Add test for preventing edit of another user's article
  - [ ] 5.5 - Add test for preventing deletion of another user's article
