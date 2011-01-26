require 'helper'
require 'adapter/riak'

describe "Riak adapter" do
  before(:each) do
    @client = Riak::Client.new(:port => 9000)['adapter_spec']
    @client.allow_mult = false
    @adapter = Adapter[:riak].new(@client)
    @adapter.clear
  end

  let(:adapter) { @adapter }
  let(:client)  { @client }

  it_should_behave_like 'a json adapter'

  describe "reading key with conflicts" do
    before(:each) do
      client.allow_mult = true
      other_adapter = Adapter[:riak].new(Riak::Client.new(:port => 9000)['adapter_spec'])

      threads = []
      threads << Thread.new { adapter.write('foo', 'bar') }
      threads << Thread.new { other_adapter.write('foo', 'baz') }
      threads.each(&:join)
    end

    it "raises conflict error" do
      lambda { adapter.read('foo') }.should raise_error(Adapter::Riak::Conflict)
    end

    it "exposes robject to exception" do
      begin
        adapter.read('foo')
      rescue Adapter::Riak::Conflict => e
        e.robject.should be_instance_of(Riak::RObject)
      end
    end
  end
end