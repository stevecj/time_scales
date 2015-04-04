require 'spec_helper'

describe TimeScales::Frame do
  context "an instance with no parts" do
    subject { described_class[] }

    it "has no year-part attributes" do
      expect( subject ).not_to respond_to( :year )
      expect( subject.methods.grep( /^year_of/ ) ). to be_empty
    end

    it "has no month-part attributes" do
      expect( subject ).not_to respond_to( :month )
      expect( subject.methods.grep( /^month_of/ ) ). to be_empty
    end
  end

  it "rejects construction with a non-Fixnum year value" do
    expect{ described_class[year: '2010'] }.to raise_error( ArgumentError )
    expect{ described_class[year: 2010.0] }.to raise_error( ArgumentError )
    expect{ described_class[year: nil]    }.to raise_error( ArgumentError )
  end

  context "an instance for a specific year" do
    subject { described_class[year: 2014] }

    it "exposes its year through its #year_of_scheme property" do
      expect( subject.year_of_scheme ).to eq( 2014 )
    end

    it "exposes its year through its #year property" do
      expect( subject.year ).to eq( 2014 )
    end

    it "is convertible to the time at the start of the year" do
      expect( subject.to_time ).to eq( Time.new(2014, 1, 1, 0, 0, 0) )
    end

    it "is convertible to range from year start until (but not including) next year start" do
      frame_start      = Time.new(2014, 1, 1, 0, 0, 0)
      next_frame_start = Time.new(2015, 1, 1, 0, 0, 0)
      expect( subject.to_range ).to eq( frame_start...next_frame_start )
    end
  end

  it "rejects construction with a non-Fixnum month value" do
    expect{ described_class[month: '10'] }.to raise_error( ArgumentError )
    expect{ described_class[month: 11.0] }.to raise_error( ArgumentError )
    expect{ described_class[month: nil]  }.to raise_error( ArgumentError )
  end

  context "an instance for a specific month" do
    subject { described_class[month: 11] }

    it "exposes its month through its #month_of_year property" do
      expect( subject.month_of_year ).to eq( 11 )
    end

    it "exposes its month through its #month property" do
      expect( subject.month ).to eq( 11 )
    end

    it "is not convertible to a time or a range" do
      expect( subject ).not_to respond_to( :to_time )
      expect( subject ).not_to respond_to( :to_range )
    end
  end

  context "an instance for a specific year and month" do
    subject { described_class[year: 2001, month: 10] }
    let( :subject_2 ) { described_class[year: 2015, month: 12] }

    it "exposes its year through its #year_of_scheme property" do
      expect( subject.year_of_scheme ).to eq( 2001 )
    end

    it "exposes its year through its #year property" do
      expect( subject.year ).to eq( 2001 )
    end

    it "exposes its month through its #month_of_year property" do
      expect( subject.month_of_year ).to eq( 10 )
    end

    it "exposes its month through its #month property" do
      expect( subject.month ).to eq( 10 )
    end

    it "is convertible to the time at the start of the month" do
      expect( subject.to_time ).to eq( Time.new(2001, 10, 1, 0, 0, 0) )
    end

    it "is convertible to range from month start until (but not including) next month start" do
      frame_start      = Time.new(2001, 10, 1, 0, 0, 0)
      next_frame_start = Time.new(2001, 11, 1, 0, 0, 0)
      expect( subject.to_range ).to eq( frame_start...next_frame_start )

      frame_start      = Time.new(2015, 12, 1, 0, 0, 0)
      next_frame_start = Time.new(2016,  1, 1, 0, 0, 0)
      expect( subject_2.to_range ).to eq( frame_start...next_frame_start )
    end
  end

end