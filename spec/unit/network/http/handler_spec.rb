#! /usr/bin/env ruby
require 'spec_helper'
require 'puppet/network/http'
require 'puppet/network/http/handler'
require 'puppet/network/authorization'
require 'puppet/network/authentication'

describe Puppet::Network::HTTP::Handler do
<<<<<<< HEAD
=======
  before :each do
    class Puppet::TestModel
      extend Puppet::Indirector
      indirects :test_model
      attr_accessor :name, :data
      def initialize(name = "name", data = '')
        @name = name
        @data = data
      end

      def self.from_raw(raw)
        new(nil, raw)
      end

      def self.from_pson(pson)
        new(pson["name"], pson["data"])
      end

      def to_pson
        {
          "name" => @name,
          "data" => @data
        }.to_pson
      end

      def ==(other)
        other.is_a? Puppet::TestModel and other.name == name and other.data == data
      end
    end

    class Puppet::TestModel::Memory < Puppet::Indirector::Memory
      def supports_remote_requests?
        true
      end
    end

    Puppet::TestModel.indirection.terminus_class = :memory
  end

  after :each do
    Puppet::TestModel.indirection.delete
    # Remove the class, unlinking it from the rest of the system.
    Puppet.send(:remove_const, :TestModel)
  end

  let(:terminus_class) { Puppet::TestModel::Memory }
  let(:terminus) { Puppet::TestModel.indirection.terminus(:memory) }
  let(:indirection) { Puppet::TestModel.indirection }
  let(:model) { Puppet::TestModel }

  def a_request
    {
      :accept_header => "pson",
      :content_type_header => "text/yaml",
      :http_method => "HEAD",
      :path => "/production/#{indirection.name}/unknown",
      :params => {},
      :client_cert => nil,
      :headers => {},
      :body => nil
    }
  end

  def a_request_that_heads(data, request = {})
    {
      :accept_header => request[:accept_header],
      :content_type_header => "text/yaml",
      :http_method => "HEAD",
      :path => "/production/#{indirection.name}/#{data.name}",
      :params => {},
      :client_cert => nil,
      :body => nil
    }
  end

  def a_request_that_submits(data, request = {})
    {
      :accept_header => request[:accept_header],
      :content_type_header => "text/yaml",
      :http_method => "PUT",
      :path => "/production/#{indirection.name}/#{data.name}",
      :params => {},
      :client_cert => nil,
      :body => data.render("text/yaml")
    }
  end

  def a_request_that_destroys(data, request = {})
    {
      :accept_header => request[:accept_header],
      :content_type_header => "text/yaml",
      :http_method => "DELETE",
      :path => "/production/#{indirection.name}/#{data.name}",
      :params => {},
      :client_cert => nil,
      :body => ''
    }
  end

  def a_request_that_finds(data, request = {})
    {
      :accept_header => request[:accept_header],
      :content_type_header => "text/yaml",
      :http_method => "GET",
      :path => "/production/#{indirection.name}/#{data.name}",
      :params => {},
      :client_cert => nil,
      :body => ''
    }
  end

  def a_request_that_searches(key, request = {})
    {
      :accept_header => request[:accept_header],
      :content_type_header => "text/yaml",
      :http_method => "GET",
      :path => "/production/#{indirection.name}s/#{key}",
      :params => {},
      :client_cert => nil,
      :body => ''
    }
  end

>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
  let(:handler) { TestingHandler.new }

  it "should include the v1 REST API" do
    Puppet::Network::HTTP::Handler.ancestors.should be_include(Puppet::Network::HTTP::API::V1)
  end

  it "should include the Rest Authorization system" do
    Puppet::Network::HTTP::Handler.ancestors.should be_include(Puppet::Network::Authorization)
  end

  describe "when initializing" do
    it "should fail when no server type has been provided" do
      lambda { handler.initialize_for_puppet }.should raise_error(ArgumentError)
    end

    it "should set server type" do
      handler.initialize_for_puppet("foo")
      handler.server.should == "foo"
    end
  end

  describe "when processing a request" do
<<<<<<< HEAD
    let(:request) do
      {
        :accept_header => "format_one,format_two",
        :content_type_header => "text/yaml",
        :http_method => "GET",
        :path => "/my_handler/my_result",
        :params => {},
        :client_cert => nil
      }
    end

    let(:response) { mock('http response') }
=======
    let(:response) do
      { :status => 200 }
    end
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313

    before do
      @model_class = stub('indirected model class')
      @indirection = stub('indirection')
      @model_class.stubs(:indirection).returns(@indirection)

      @result = stub 'result', :render => "mytext"

      request[:headers] = {
          "Content-Type"  => request[:content_type_header],
          "Accept"        => request[:accept_header]
      }

      handler.stubs(:check_authorization)
      handler.stubs(:warn_if_near_expiration)
      handler.stubs(:headers).returns(request[:headers])
    end

    it "should check the client certificate for upcoming expiration" do
      cert = mock 'cert'
      handler.expects(:client_cert).returns(cert).with(request)
      handler.expects(:warn_if_near_expiration).with(cert)

      handler.process(request, response)
    end

    it "should setup a profiler when the puppet-profiling header exists" do
      request[:headers][Puppet::Network::HTTP::HEADER_ENABLE_PROFILING.downcase] = "true"

      handler.process(request, response)

      Puppet::Util::Profiler.current.should be_kind_of(Puppet::Util::Profiler::WallClock)
    end

    it "should not setup profiler when the profile parameter is missing" do
      request[:params] = { }

      handler.process(request, response)

      Puppet::Util::Profiler.current.should == Puppet::Util::Profiler::NONE
    end

    it "should create an indirection request from the path, parameters, and http method" do
      request[:path] = "mypath"
      request[:http_method] = "mymethod"
      request[:params] = { :params => "mine" }

      handler.expects(:uri2indirection).with("mymethod", "mypath", { :params => "mine" }).returns stub("request", :method => :find)

      handler.stubs(:do_find)

      handler.process(request, response)
    end

<<<<<<< HEAD
    it "should call the 'do' method and delegate authorization to the authorization layer" do
=======
    it "should return 403 if the request is not authorized" do
      request = a_request
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      handler.expects(:uri2indirection).returns(["facts", :mymethod, "key", {:node => "name"}])

      handler.expects(:do_mymethod).never

      handler.expects(:check_authorization).with("facts", :mymethod, "key", {:node => "name"}).raises(Puppet::Network::AuthorizationError.new("forbidden"))

      handler.expects(:set_response).with(anything, anything, 403)

      handler.process(request, response)
    end

<<<<<<< HEAD
    it "should return 403 if the request is not authorized" do
      handler.expects(:uri2indirection).returns(["facts", :mymethod, "key", {:node => "name"}])

      handler.expects(:do_mymethod).never

      handler.expects(:check_authorization).with("facts", :mymethod, "key", {:node => "name"}).raises(Puppet::Network::AuthorizationError.new("forbidden"))
=======
    it "should return an error code if the indirection does not support remote requests" do
      request = a_request
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313

      indirection.expects(:allow_remote_requests?).returns(false)

      handler.process(request, response)

      expect(response[:status]).to eq 404
    end

    it "should serialize a controller exception when an exception is thrown while finding the model instance" do
<<<<<<< HEAD
      handler.expects(:uri2indirection).returns(["facts", :find, "key", {:node => "name"}])
=======
      request = a_request_that_finds(Puppet::TestModel.new("key"))
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313

      handler.expects(:do_find).raises(ArgumentError, "The exception")
      handler.expects(:set_response).with(anything, "The exception", 400)
      handler.process(request, response)
    end

    it "should set the format to text/plain when serializing an exception" do
      handler.expects(:set_content_type).with(response, "text/plain")
<<<<<<< HEAD
      handler.do_exception(response, "A test", 404)
    end

=======

      handler.do_exception(response, Exception.new("A test"), 404)
    end

    it "sends an exception string with the given status" do
      handler.expects(:set_response).with(response, "A test", 404)

      handler.do_exception(response, Exception.new("A test"), 404)
    end

    it "sends an exception error with the exception's status" do
      data = Puppet::TestModel.new("not_found", "not found")
      request = a_request_that_finds(data, :accept_header => "pson")

      error = Puppet::Network::HTTP::Handler::HTTPNotFoundError.new("Could not find test_model not_found")
      handler.expects(:set_response).with(response, error.to_s, error.status)

      handler.process(request, response)
    end

    it "logs an HTTP response exception at info level (most are harmless)" do
      data = Puppet::TestModel.new("not_found", "not found")
      error = Puppet::Network::HTTP::Handler::HTTPNotFoundError.new("Could not find test_model not_found")

      request = a_request_that_finds(data, :accept_header => "pson")
      Puppet.expects(:info).with(error.message)

      handler.process(request, response)
    end

>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
    it "should raise an error if the request is formatted in an unknown format" do
      handler.stubs(:content_type_header).returns "unknown format"
      lambda { handler.request_format(request) }.should raise_error
    end

    it "should still find the correct format if content type contains charset information" do
      handler.stubs(:content_type_header).returns "text/plain; charset=UTF-8"
      handler.request_format(request).should == "s"
    end

    it "should deserialize YAML parameters" do
      params = {'my_param' => [1,2,3].to_yaml}

      decoded_params = handler.send(:decode_params, params)

      decoded_params.should == {:my_param => [1,2,3]}
    end

    it "should accept YAML parameters with !ruby/hash tags on Ruby 1.8", :if => RUBY_VERSION =~ /^1\.8/ do
      params = {'my_param' => "--- !ruby/hash:Array {}"}

      decoded_params = handler.send(:decode_params, params)

      decoded_params[:my_param].should be_an(Array)
    end

    # These are only dangerous with Psych, which is Ruby 1.9-only. Since
    # there's no real way to change the yamler in Puppet, assume that 1.9 means
    # Psych, especially in tests.
    it "should fail if YAML parameters have !ruby/hash tags on Ruby 1.9", :unless => RUBY_VERSION =~ /^1\.8/ do
      params = {'my_param' => "--- !ruby/hash:Array {}"}

      expect { handler.send(:decode_params, params) }.to raise_error(ArgumentError, /Illegal YAML mapping found/)
    end

    describe "when finding a model instance" do
      before do
        @indirection.stubs(:find).returns @result
        Puppet::Indirector::Indirection.expects(:instance).with(:my_handler).returns( stub "indirection", :model => @model_class )

        @format = stub 'format', :suitable? => true, :mime => "text/format", :name => "format"
        Puppet::Network::FormatHandler.stubs(:format).returns @format

        @oneformat = stub 'one', :suitable? => true, :mime => "text/one", :name => "one"
        Puppet::Network::FormatHandler.stubs(:format).with("one").returns @oneformat
      end

      it "should use the indirection request to find the model class" do
        handler.do_find("my_handler", "my_result", {}, request, response)
      end

      it "should use the escaped request key" do
        @indirection.expects(:find).with("my_result", anything).returns @result
        handler.do_find("my_handler", "my_result", {}, request, response)
      end

      it "should use a common method for determining the request parameters" do
        @indirection.expects(:find).with(anything, has_entries(:foo => :baz, :bar => :xyzzy)).returns @result

        handler.do_find("my_handler", "my_result", {:foo => :baz, :bar => :xyzzy}, request, response)
      end

      it "should set the content type to the first format specified in the accept header" do
        handler.expects(:accept_header).with(request).returns "one,two"
        handler.expects(:set_content_type).with(response, @oneformat)
        handler.do_find("my_handler", "my_result", {}, request, response)
      end

      it "should fail if no accept header is provided" do
        handler.expects(:accept_header).with(request).returns nil
        lambda { handler.do_find("my_handler", "my_result", {}, request, response) }.should raise_error(ArgumentError)
      end

<<<<<<< HEAD
      it "should fail if the accept header does not contain a valid format" do
        handler.expects(:accept_header).with(request).returns ""
        lambda { handler.do_find("my_handler", "my_result", {}, request, response) }.should raise_error(RuntimeError)
=======
        handler.do_find(indirection, "my data", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should not use an unsuitable format" do
        handler.expects(:accept_header).with(request).returns "foo,bar"
        foo = mock 'foo', :suitable? => false
        bar = mock 'bar', :suitable? => true
        Puppet::Network::FormatHandler.expects(:format).with("foo").returns foo
        Puppet::Network::FormatHandler.expects(:format).with("bar").returns bar

        handler.expects(:set_content_type).with(response, bar) # the suitable one

<<<<<<< HEAD
        handler.do_find("my_handler", "my_result", {}, request, response)
=======
        expect do
          handler.do_find(indirection, "my data", {}, request, response)
        end.to raise_error(Puppet::Network::HTTP::Handler::HTTPNotAcceptableError)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should render the result using the first format specified in the accept header" do

<<<<<<< HEAD
        handler.expects(:accept_header).with(request).returns "one,two"
        @result.expects(:render).with(@oneformat)

        handler.do_find("my_handler", "my_result", {}, request, response)
=======
        expect do
          handler.do_find(indirection, "my data", {}, request, response)
        end.to raise_error(Puppet::Network::HTTP::Handler::HTTPNotAcceptableError)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should pass the result through without rendering it if the result is a string" do
        @indirection.stubs(:find).returns "foo"
        handler.expects(:set_response).with(response, "foo")
        handler.do_find("my_handler", "my_result", {}, request, response)
      end

      it "should use the default status when a model find call succeeds" do
        handler.expects(:set_response).with(anything, anything, nil)
        handler.do_find("my_handler", "my_result", {}, request, response)
      end

      it "should return a serialized object when a model find call succeeds" do
        @model_instance = stub('model instance')
        @model_instance.expects(:render).returns "my_rendered_object"

<<<<<<< HEAD
        handler.expects(:set_response).with(anything, "my_rendered_object", anything)
        @indirection.stubs(:find).returns(@model_instance)
        handler.do_find("my_handler", "my_result", {}, request, response)
=======
        handler.do_find(indirection, "my data", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should return a 404 when no model instance can be found" do
        @model_class.stubs(:name).returns "my name"
        handler.expects(:set_response).with(anything, anything, 404)
        @indirection.stubs(:find).returns(nil)
        handler.do_find("my_handler", "my_result", {}, request, response)
      end

      it "should write a log message when no model instance can be found" do
        @model_class.stubs(:name).returns "my name"
        @indirection.stubs(:find).returns(nil)

<<<<<<< HEAD
        Puppet.expects(:info).with("Could not find my_handler for 'my_result'")

        handler.do_find("my_handler", "my_result", {}, request, response)
      end


      it "should serialize the result in with the appropriate format" do
        @model_instance = stub('model instance')

        handler.expects(:format_to_use).returns(@oneformat)
        @model_instance.expects(:render).with(@oneformat).returns "my_rendered_object"
        @indirection.stubs(:find).returns(@model_instance)
        handler.do_find("my_handler", "my_result", {}, request, response)
=======
        expect do
          handler.do_find(indirection, "my data", {}, request, response)
        end.to raise_error(Puppet::Network::HTTP::Handler::HTTPNotFoundError)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end
    end

    describe "when performing head operation" do
      before do
        handler.stubs(:model).with("my_handler").returns(stub 'model', :indirection => @model_class)
        request[:http_method] = "HEAD"
        request[:path] = "/production/my_handler/my_result"
        request[:params] = {}

        @model_class.stubs(:head).returns true
      end

      it "should use the escaped request key" do
        @model_class.expects(:head).with("my_result", anything).returns true
        handler.process(request, response)
      end

      it "should not generate a response when a model head call succeeds" do
        handler.expects(:set_response).never
        handler.process(request, response)
      end

      it "should return a 404 when the model head call returns false" do
        handler.expects(:set_response).with(anything, anything, 404)
        @model_class.stubs(:head).returns(false)
        handler.process(request, response)
      end
    end

    describe "when searching for model instances" do
      before do
        Puppet::Indirector::Indirection.expects(:instance).with(:my_handler).returns( stub "indirection", :model => @model_class )

        result1 = mock 'result1'
        result2 = mock 'results'

        @result = [result1, result2]
        @model_class.stubs(:render_multiple).returns "my rendered instances"
        @indirection.stubs(:search).returns(@result)

<<<<<<< HEAD
        @format = stub 'format', :suitable? => true, :mime => "text/format", :name => "format"
        Puppet::Network::FormatHandler.stubs(:format).returns @format

        @oneformat = stub 'one', :suitable? => true, :mime => "text/one", :name => "one"
        Puppet::Network::FormatHandler.stubs(:format).with("one").returns @oneformat
=======
        handler.do_search(indirection, "my", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should use the indirection request to find the model" do
        handler.do_search("my_handler", "my_result", {}, request, response)
      end

      it "should use a common method for determining the request parameters" do
        @indirection.expects(:search).with(anything, has_entries(:foo => :baz, :bar => :xyzzy)).returns @result
        handler.do_search("my_handler", "my_result", {:foo => :baz, :bar => :xyzzy}, request, response)
      end

<<<<<<< HEAD
      it "should use the default status when a model search call succeeds" do
        @indirection.stubs(:search).returns(@result)
        handler.do_search("my_handler", "my_result", {}, request, response)
=======
        handler.do_search(indirection, "nothing", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should set the content type to the first format returned by the accept header" do
        handler.expects(:accept_header).with(request).returns "one,two"
        handler.expects(:set_content_type).with(response, @oneformat)

<<<<<<< HEAD
        handler.do_search("my_handler", "my_result", {}, request, response)
=======
        expect do
          handler.do_search(indirection, "nothing", {}, request, response)
        end.to raise_error(Puppet::Network::HTTP::Handler::HTTPNotFoundError)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should return a list of serialized objects when a model search call succeeds" do
        handler.expects(:accept_header).with(request).returns "one,two"

        @indirection.stubs(:search).returns(@result)

        @model_class.expects(:render_multiple).with(@oneformat, @result).returns "my rendered instances"

        handler.expects(:set_response).with(anything, "my rendered instances")
        handler.do_search("my_handler", "my_result", {}, request, response)
      end

      it "should return [] when searching returns an empty array" do
        handler.expects(:accept_header).with(request).returns "one,two"
        @indirection.stubs(:search).returns([])
        @model_class.expects(:render_multiple).with(@oneformat, []).returns "[]"

<<<<<<< HEAD
=======
        handler.do_destroy(indirection, "my data", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313

        handler.expects(:set_response).with(anything, "[]")
        handler.do_search("my_handler", "my_result", {}, request, response)
      end

      it "should return a 404 when searching returns nil" do
        @model_class.stubs(:name).returns "my name"
        handler.expects(:set_response).with(anything, anything, 404)
        @indirection.stubs(:search).returns(nil)
        handler.do_search("my_handler", "my_result", {}, request, response)
      end
    end

    describe "when destroying a model instance" do
      before do
        Puppet::Indirector::Indirection.expects(:instance).with(:my_handler).returns( stub "indirection", :model => @model_class )

        @result = stub 'result', :render => "the result"
        @indirection.stubs(:destroy).returns @result
      end

<<<<<<< HEAD
      it "should use the indirection request to find the model" do
        handler.do_destroy("my_handler", "my_result", {}, request, response)
=======
        handler.do_destroy(indirection, "my data", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should use the escaped request key to destroy the instance in the model" do
        @indirection.expects(:destroy).with("foo bar", anything)
        handler.do_destroy("my_handler", "foo bar", {}, request, response)
      end

      it "should use a common method for determining the request parameters" do
        @indirection.expects(:destroy).with(anything, has_entries(:foo => :baz, :bar => :xyzzy))
        handler.do_destroy("my_handler", "my_result", {:foo => :baz, :bar => :xyzzy}, request, response)
      end

<<<<<<< HEAD
      it "should use the default status code a model destroy call succeeds" do
        handler.expects(:set_response).with(anything, anything, nil)
        handler.do_destroy("my_handler", "my_result", {}, request, response)
=======
        handler.do_destroy(indirection, "my data", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should return a yaml-encoded result when a model destroy call succeeds" do
        @result = stub 'result', :to_yaml => "the result"
        @indirection.expects(:destroy).returns(@result)

<<<<<<< HEAD
        handler.expects(:set_response).with(anything, "the result", anything)
=======
        expect do
          handler.do_destroy(indirection, "my data", {}, request, response)
        end.to raise_error(Puppet::Network::HTTP::Handler::HTTPNotAcceptableError)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313

        handler.do_destroy("my_handler", "my_result", {}, request, response)
      end
    end

    describe "when saving a model instance" do
<<<<<<< HEAD
      before do
        Puppet::Indirector::Indirection.stubs(:instance).with(:my_handler).returns( stub "indirection", :model => @model_class )
        handler.stubs(:body).returns('my stuff')
        handler.stubs(:content_type_header).returns("text/yaml")

        @result = stub 'result', :render => "the result"

        @model_instance = stub('indirected model instance')
        @model_class.stubs(:convert_from).returns(@model_instance)
        @indirection.stubs(:save)

        @format = stub 'format', :suitable? => true, :name => "format", :mime => "text/format"
        Puppet::Network::FormatHandler.stubs(:format).returns @format
        @yamlformat = stub 'yaml', :suitable? => true, :name => "yaml", :mime => "text/yaml"
        Puppet::Network::FormatHandler.stubs(:format).with("yaml").returns @yamlformat
=======
      it "allows an empty body when the format supports it" do
        class Puppet::TestModel::Nonvalidatingmemory < Puppet::TestModel::Memory
          def validate_key(_)
            # nothing
          end
        end

        indirection.terminus_class = :nonvalidatingmemory

        data = Puppet::TestModel.new("test", '')
        request = a_request_that_submits(data)
        request[:content_type_header] = "application/x-raw"
        request[:body] = ''

        handler.do_save(indirection, "test", {}, request, response)

        Puppet::TestModel.indirection.find("test").data.should == ''
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should use the indirection request to find the model" do
        handler.do_save("my_handler", "my_result", {}, request, response)
      end

<<<<<<< HEAD
      it "should use the 'body' hook to retrieve the body of the request" do
        handler.expects(:body).returns "my body"
        @model_class.expects(:convert_from).with(anything, "my body").returns @model_instance
=======
        handler.do_save(indirection, "my data", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313

        handler.do_save("my_handler", "my_result", {}, request, response)
      end

      it "should fail to save model if data is not specified" do
        handler.stubs(:body).returns('')

        lambda { handler.do_save("my_handler", "my_result", {}, request, response) }.should raise_error(ArgumentError)
      end

<<<<<<< HEAD
      it "should use a common method for determining the request parameters" do
        @indirection.expects(:save).with(@model_instance, 'key').once
        handler.do_save("my_handler", "key", {}, request, response)
=======
        handler.do_save(indirection, "my data", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should use the default status when a model save call succeeds" do
        handler.expects(:set_response).with(anything, anything, nil)
        handler.do_save("my_handler", "my_result", {}, request, response)
      end

      it "should return the yaml-serialized result when a model save call succeeds" do
        @indirection.stubs(:save).returns(@model_instance)
        @model_instance.expects(:to_yaml).returns('foo')
        handler.do_save("my_handler", "my_result", {}, request, response)
      end

<<<<<<< HEAD
      it "should set the content to yaml" do
        handler.expects(:set_content_type).with(response, @yamlformat)
        handler.do_save("my_handler", "my_result", {}, request, response)
=======
        handler.do_save(indirection, "my data", {}, request, response)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
      end

      it "should use the content-type header to know the body format" do
        handler.expects(:content_type_header).returns("text/format")
        Puppet::Network::FormatHandler.stubs(:mime).with("text/format").returns @format

<<<<<<< HEAD
        @model_class.expects(:convert_from).with("format", anything).returns @model_instance
=======
        expect do
          handler.do_save(indirection, "my data", {}, request, response)
        end.to raise_error(Puppet::Network::HTTP::Handler::HTTPNotAcceptableError)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313

        handler.do_save("my_handler", "my_result", {}, request, response)
      end
    end
  end

  describe "when resolving node" do
    it "should use a look-up from the ip address" do
      Resolv.expects(:getname).with("1.2.3.4").returns("host.domain.com")

      handler.resolve_node(:ip => "1.2.3.4")
    end

    it "should return the look-up result" do
      Resolv.stubs(:getname).with("1.2.3.4").returns("host.domain.com")

      handler.resolve_node(:ip => "1.2.3.4").should == "host.domain.com"
    end

    it "should return the ip address if resolving fails" do
      Resolv.stubs(:getname).with("1.2.3.4").raises(RuntimeError, "no such host")

      handler.resolve_node(:ip => "1.2.3.4").should == "1.2.3.4"
    end
  end

  class TestingHandler
    include Puppet::Network::HTTP::Handler

    def accept_header(request)
      request[:accept_header]
    end

    def content_type_header(request)
      request[:content_type_header]
    end

    def set_content_type(response, format)
      "my_result"
    end

    def set_response(response, body, status = 200)
      response[:body] = body
      response[:status] = status
    end

    def http_method(request)
      request[:http_method]
    end

    def path(request)
      request[:path]
    end

    def params(request)
      request[:params]
    end

    def client_cert(request)
      request[:client_cert]
    end
  end
end
