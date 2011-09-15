require 'spec_helper'

describe Bot do
  before :each do
    @bot1 = Bot.new
    @bot2 = Bot.new
  end

  after :each do
    Bot.clear
  end

  context "identification" do 
    it "should have a name" do
      @bot1.name.should_not be_empty
    end

    it "should allow me to change it's name" do
      @bot1.name = "test"
    end
    
    it "should be able to identify itself independent of it's name" do
      @bot1.name = "test"
      @bot2.name = "test"
      @bot2.should_not == @bot1
    end
    
    it "should be able to uniquely identify itself amongst several bots" do
      @bot2.should_not == @bot1
    end

    it "should be able to compare itself to another bot, and tell me if they're the same" do
      @bot1.should_not == @bot2
      @bot2.should == @bot2
    end
  end

  context "class actions" do
    it "should be able to return a count of all the bots in existence" do
      Bot.clear
      Bot.new
      Bot.count.should == 1
      Bot.new
      Bot.count.should == 2
    end

    it "should be able to reset it's knowledge of all bots" do
      Bot.new
      Bot.new
      Bot.new
      Bot.count.should_not == 0
      Bot.clear
      Bot.count.should == 0
    end

    it "should add itself to a registry of bots, indexed by name" do
      Bot.find_by_name("bot-1").should == @bot1
      Bot.find_by_name("bot-2").should == @bot2
    end
  end

  context "health" do
    it "should be able to track it's health" do 
      @bot1.health.should_not be_nil
    end

    it "should be able to lose health" do
      orig_health = @bot1.health
      @bot1.hurt_for(1).health.should be < orig_health
    end

    it "should let me set it's health" do
      @bot1.health = 100
      @bot1.health.should == 100
      @bot1.health = 1000
      @bot1.health.should == 1000
    end

    it "should be able to tell me if it's dead" do
      @bot1.hurt_for(@bot1.health * 2).should be_dead
    end

    it "should be alive by default" do
      @bot1.should be_alive
      @bot1.should_not be_dead
    end
  end

  context "movement and location" do
    it "should have a location" do 
      @bot1.location.should_not be_nil
    end
    
    it "should be able to move to a new, random location" do
      #demeter violation here, #location should return a copy of the loc object
      old_location = @bot1.location.coordinates
      @bot1.move
      old_location.should_not == @bot1.location.coordinates
    end

    it "should be able to move from it's current location to another" do
      @bot1.move(:to => Location[8, 9])
      @bot1.location.should == Location[8, 9]
    end
  end
end
