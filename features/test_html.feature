Feature: Testing a custom HTML backend

  Background:
    Given I do have a template-based HTML backend with DocTest

  Scenario: Some examples do not match the expected output
    When I run `bundle exec rake doctest:test`
    Then the output should contain:
      """
      Running DocTest for the templates: templates.

      FSS.SF
      """
    Then the output should contain:
      """
      ✗  Failure: quote:with-attribution
         Failing example..

            <div class="quoteblock">
              <blockquote>A person who never made a mistake <em>never</em> tried anything new.</blockquote>
         E    <div>Albert Einstein</div>
         A    <div class="attribution">— Albert Einstein</div>
            </div>
      """
    And the output should contain:
      """
      ✗  Failure: document:title-with-author
         This example should fail..

            <div id="header">
              <h1>The Dangerous and Thrilling Documentation Chronicles</h1>
         E    <div id="author">Kismet Rainbow Chameleon</div>
         A    <div class="details"><span id="author">Kismet Rainbow Chameleon</span></div>
            </div>
      """
    And the output should contain:
      """
      6 examples (1 passed, 2 failed, 3 skipped)
      """
    And the output should contain:
      """
      You have skipped tests. Run with VERBOSE=yes for details.
      """

    When I run `bundle exec rake doctest:test VERBOSE=yes`
    Then the output should contain:
      """
      Running DocTest for the templates: templates.

      ✗  document:title-with-author
      ∅  inline_quoted:emphasis
      ∅  inline_quoted2:bold
      ✓  quote:with-id-and-role
      ∅  quote:with-title
      ✗  quote:with-attribution

      """
    And the output should contain:
      """
      ∅  Skipped: quote:with-title
         No expected output found
      """
    And the output should contain:
      """
      ∅  Skipped: inline_quoted:emphasis
         No expected output found
      """

  Scenario: Test only examples matching the pattern
    When I run `bundle exec rake doctest:test PATTERN=quot*:* VERBOSE=yes`
    Then the output should contain:
      """
      Running DocTest for the templates: templates.

      ✓  quote:with-id-and-role
      ∅  quote:with-title
      ✗  quote:with-attribution

      """

  Scenario: A necessary template is missing and fallback to the built-in converter is disabled
    When I remove the file "templates/inline_quoted.html.slim"
    And I run `bundle exec rake doctest:test`
    Then the output should contain:
      """
      Could not find a custom template to handle template_name: inline_quoted
      """
    And the output should contain:
      """
      ✗  Failure: quote:with-attribution
         Failing example..

            <div class="quoteblock">
         E    <blockquote>A person who never made a mistake <em>never</em> tried anything new.</blockquote>
         E    <div>Albert Einstein</div>
         A    <blockquote>A person who never made a mistake --TEMPLATE NOT FOUND-- tried anything new.</blockquote>
         A    <div class="attribution">— Albert Einstein</div>
            </div>
      """
