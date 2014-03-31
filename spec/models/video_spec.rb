describe Trim::Video do
  describe '#caption' do
    it 'should return nil for nil titles' do
      expect(Trim::Video.make(:caption => nil).caption).to be_nil
    end
  end
end
