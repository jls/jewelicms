require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  # Test the value for method
  test "value_for returns nil for fields not set" do
    assert_equal articles(:blog_hello_world_article).value_for("Non-existant Field"), nil
  end

  test "value_for returns correct summary field" do
    @article = articles(:blog_hello_world_article)
    assert_equal @article.value_for('Summary'), 'How do you summarize hello world?'
  end

  test "ensure value_for return stored in cache" do
    @article = articles(:blog_hello_world_article)
    assert_equal @article.value_for('Summary'), @article.values_cache['Summary']
  end

  test "values cache is used after first call" do
    @article = articles(:blog_hello_world_article)
    original_summary = @article.value_for('Summary')
    @article.values_cache['Summary'] = "Changed!"
    assert_equal @article.value_for('Summary'), 'Changed!'
  end

  test "article get obeys channel" do
    @channel = channels(:blog_channel)
    @articles = Article.get(:channel => @channel.slug)
    assert_equal @articles.size, 2
  end

  test "article get obeys single category and is_published default" do
    @general_category = categories(:blog_general_category)
    @articles = Article.get(:category => @general_category.slug)
    #assert_equal @articles.size, 2 # 2 instead of three because one article is not published.
    puts @articles.inspect
    assert_equal @articles[0], articles(:blog_ruby_is_great_article)
    assert_equal @articles[1], articles(:blog_hello_world_article)
    assert_equal @articles[2], nil
  end

  test "article get defaults desc order" do
    @general_category = categories(:blog_general_category)
    @articles = Article.get(:category => @general_category.slug)
    assert_equal @articles.first, articles(:blog_ruby_is_great_article)
  end

  test "article get obeys multiple category" do 
    @general = categories(:blog_general_category)
    @dev = categories(:blog_development_category)
    @articles = Article.get(:category => [@general.slug, @dev.slug])
    assert_equal @articles.size, 2
  end

  test "article get by slug" do
    @articles = Article.get(:slug => 'why-ruby-is-great')
    assert_equal @articles.size, 1
    assert_equal @articles.first.title, articles(:blog_ruby_is_great_article).title
  end

  test "article get by published" do
    @articles = Article.get(:published => false)
    assert_equal @articles.size, 1
  end

  test "article get limit" do 
    @articles = Article.get(:limit => 1)
    assert_equal @articles.size, 1
  end

end
