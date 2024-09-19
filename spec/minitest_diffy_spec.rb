require 'asciidoctor/doctest/minitest_diffy'
require 'corefines'

using Corefines::String.color

describe Diffy::Format do
  describe '#minitest' do
    subject(:output) { input.minitest }

    let(:input) { [] }

    # This looks odd, but Diffy is actually using Format exactly like that.
    # https://github.com/samg/diffy/blob/6e1f1312/lib/diffy/diff.rb#L132
    before { input.extend described_class }

    it { expect(described_class).to have_method :minitest }

    context 'with line starting with ---, or +++' do
      let(:input) { ['--- a/file.rb', '+++ b/file.rb'] }

      it 'discards the line' do
        expect(output.chomp).to be_empty
      end
    end

    context 'with line with "\ No newline at end of file"' do
      let(:input) { ['\ No newline at end of file'] }

      it 'discards this line' do
        expect(output.chomp).to be_empty
      end
    end

    context 'with line starting with +' do
      let(:input) { ['+ <div><p>chunky bacon</p></div>'] }

      it 'replaces "+" with "A", adds padding and colour' do
        expect(subject).to eq "\n" + 'A   <div><p>chunky bacon</p></div>'.color(:red)
      end
    end

    context 'with line starting with -' do
      let(:input) { ['- <p>chunky bacon</p>'] }

      it 'replaces "-" with "E", adds padding and colour' do
        expect(subject).to eq "\n" + 'E   <p>chunky bacon</p>'.color(:green)
      end
    end

    context 'with normal lines' do
      let(:input) { ['Lorem ipsum dolor', '  sit amet'] }

      it 'returns the lines with padding' do
        expect(subject).to eq "\n  Lorem ipsum dolor\n    sit amet"
      end
    end
  end
end
