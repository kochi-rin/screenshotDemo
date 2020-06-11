require 'rubygems'
require 'plist'

TEST_LOG_PATH = "./TestOutput/Logs/Test/"

module XCTestSummaryParser
  class TestableSummary
    attr_accessor :tests

    def initialize(dict)
      @tests = dict['Tests'].map{ |test| Test.new(test) }
    end

    def to_html
      @tests.inject('') { |html, test| html += test.to_html }
    end
  end

  class Test
    attr_accessor :sub_tests, :activity_summaries

    def initialize(dict)
      if dict['ActivitySummaries']
        @activity_summaries = dict['ActivitySummaries'].map { |summary| ActivitySummary.new(summary) }
      end

      if dict['Subtests']
        @sub_tests = dict['Subtests'].map { |test| Test.new(test) }
      end
    end

    def to_html
      html = ''
      html += @activity_summaries.inject('') { |html, test| html += test.to_html } if @activity_summaries
      html += @sub_tests.inject('') { |html, test| html += test.to_html } if @sub_tests
      html
    end
  end

  class ActivitySummary
    attr_accessor :title, :sub_activities, :attachments

    def initialize(dict)
      fail 'invalid dictionary' unless dict['Title']
      @title = dict['Title']
      if dict['SubActivities']
        @sub_activities = dict['SubActivities'].map { |sub_act| ActivitySummary.new(sub_act) }
      end
      @attachments = dict['Attachments']
    end

    def to_html
      attachment_path = "#{TEST_LOG_PATH}/Attachments"

      html = ''
      if @attachments
        @attachments.each do |attachment|
          next if attachment['Extension'] != 'png'
          filepath = "#{attachment_path}/#{attachment['FileName']}"
          html += "  <img src='#{filepath}' style='max-height: 300px; height:auto; width:auto; display:inline;'>\n"
        end
      end
      if @sub_activities
        @sub_activities.each do |sub_activity|
          html += sub_activity.to_html
        end
      end
      html
    end
  end
end

def build_testable_summaries
  filename = Dir.glob("#{TEST_LOG_PATH}/*TestSummaries.plist").first
  plist = Plist::parse_xml(filename)
  plist['TestableSummaries'].map {|testable_summary| XCTestSummaryParser::TestableSummary.new(testable_summary) }
end

File.open('test_summary.html', 'w') do |f|
  f.puts '<html>'
  f.puts '<body>'

  summaries = build_testable_summaries
  f.puts summaries.map(&:to_html)

  f.puts '</body>'
  f.puts '</html>'
end
