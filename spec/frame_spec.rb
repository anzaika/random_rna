require_relative "spec_helper"

RSpec.describe "" do

  describe "#stops" do
    context "For frame ATGTAG" do
      it "returns one stop" do
        f = Frame.new("ATGTAG")
        expect(f.stops.count).to eq(1)
      end
    end
    context "For frame ATGTAGCCCTGA" do
      it "returns two stops" do
        f = Frame.new("ATGTAGCCCTGA")
        expect(f.stops.count).to eq(2)
      end
    end
  end

  describe "#stop_types_count" do
    context "for frame ATGTAG" do
      it "returns 1" do
        f = Frame.new("ATGTAG")
        expect(f.stop_types_count).to eq(1)
      end
    end
    context "for frame ATGTAGCCCTAG" do
      it "returns 1" do
        f = Frame.new("ATGTAGCCCTAG")
        expect(f.stop_types_count).to eq(1)
      end
    end
    context "for frame ATGTAACCCTGA" do
      it "returns 2" do
        f = Frame.new("ATGTAACCCTGA")
        expect(f.stop_types_count).to eq(2)
      end
    end
    context "for frame ATGTAACCCTGATTTTAG" do
      it "returns 3" do
        f = Frame.new("ATGTAACCCTGATTTTAG")
        expect(f.stop_types_count).to eq(3)
      end
    end
  end

  describe "#stop_type_pct" do
    context "for frame ATGTAG" do
      it "for type 'amber' it returns 100" do
        f = Frame.new("ATGTAG")
        expect(f.stop_type_pct('amber')).to eq(100)
      end
      it "for type 'opal' it returns 0" do
        f = Frame.new("ATGTAG")
        expect(f.stop_type_pct('opal')).to eq(0)
      end
    end
    context "for frame ATGTGACCCTGATTTTAG" do
      it "for type 'amber' it returns 33" do
        f = Frame.new("ATGTGACCCTGATTTTAG")
        expect(f.stop_type_pct('opal')).to eq(67)
      end
    end
    context "for frame ATGTAACCCTGATTTTAG" do
      it "for type 'amber' it returns 33" do
        f = Frame.new("ATGTAACCCTGATTTTAG")
        expect(f.stop_type_pct('amber')).to eq(33)
      end
    end
  end

  describe "#stop_avg_distance" do
  end

end
