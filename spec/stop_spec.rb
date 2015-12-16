require_relative "spec_helper"

RSpec.describe "Stop" do
  describe "::codon?" do
    it "retuns true for TAG" do
      expect(Stop.codon?("TAG")).to be(true)
    end
    it "retuns true for TAA" do
      expect(Stop.codon?("TAA")).to be(true)
    end
    it "retuns true for TGA" do
      expect(Stop.codon?("TGA")).to be(true)
    end
    it "retuns false for AT" do
      expect(Stop.codon?("ATG")).to be(false)
    end
  end

  describe "::avg_distance" do
    context "with use_segments_distance=false" do
      it "returns 2 for stops [TAG,1],[TAA,3]" do
        a = Stop.new("TAG", 1)
        b = Stop.new("TAA", 3)
        expect(Stop.avg_distance([a,b], false)).to eq(2)
      end
    end
    context "with use_segments_distance=true" do
      it "returns 2 for stops [TAG,1],[TAA,3]" do
        a = Stop.new("TAG", 1)
        b = Stop.new("TAA", 3)
        expect(Stop.avg_distance([a,b], true)).to eq(2)
      end
      it "returns 2 for stops [TAG,1],[TAA,3],[TAG,8]" do
        a = Stop.new("TAG", 1)
        b = Stop.new("TAA", 3)
        c = Stop.new("TAG", 8)
        expect(Stop.avg_distance([a,b,c], true)).to eq(3.5)
      end
    end
  end
end
