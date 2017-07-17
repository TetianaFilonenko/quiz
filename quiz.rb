require 'mechanize'
require 'nokogiri'

class Quiz
  def run
    Parser::Manager.new.process
  end
end

module Parser
  class Configuration
    attr_accessor :form_id
    attr_accessor :email
    attr_accessor :password

    def initialize
      @form_id  = 'form-signin'
      @email    = 'test@example.com'
      @password = 'secret'
    end
  end

  class Manager
    def process
      page_url = 'https://staqresults.herokuapp.com'
      handler = RequestHandler.new
      responder = ResponseProcessor.new
      results = handler.process(page_url)
      responder.process(results)
    end
  end

  class RequestHandler
    attr_accessor :config

    def initialize(config = Configuration.new)
      @agent = Mechanize.new
      @config = config
    end

    def process(url)
      page = @agent.get url
      login_form = page.form_with(id: config.form_id)
      login_form.field_with(name: 'email').value = config.email
      login_form.field_with(name: 'password').value = config.password
      @agent.submit login_form
    end
  end

  class ResponseProcessor
    def process(response)
      response.search('tbody/tr').inject({}) do |result_hash, row|
        columns = row.search('td')
        presenter = Presenter.new(columns)
        result_hash[presenter.date] = presenter.summary_json
        result_hash
      end
    end
  end

  class Presenter
    def initialize(columns)
      @columns = columns
    end

    def date
      @columns[0].text
    end

    def summary_json
      { tests:    tests,
        passes:   passes,
        failures: failures,
        pending:  pending,
        coverage: coverage }
    end

    private

    def tests
      @columns[1].text
    end

    def passes
      @columns[2].text
    end

    def failures
      @columns[3].text
    end

    def pending
      @columns[4].text
    end

    def coverage
      @columns[5].text
    end
  end
end
