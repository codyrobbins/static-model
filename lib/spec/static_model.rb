shared_examples_for 'StaticModel' do
  describe '#initialize' do
    it 'sets the attributes' do
      described_class.any_instance.expects(:attribute_1=).with(1)
      described_class.any_instance.expects(:attribute_2=).with(2)

      described_class.new(:attribute_1 => 1, :attribute_2 => 2)
    end
  end

  describe '#persisted?' do
    subject { described_class.new.persisted? }
    it { should be_false }
  end
end
