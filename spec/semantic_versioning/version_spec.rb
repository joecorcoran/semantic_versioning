require 'spec_helper'

describe SemanticVersioning::Version do

  let(:version) { v('1.2.3-pre.1+build.2') }

  describe 'accepts only properly formatted strings' do
    specify do
      lambda { v('1.0.0-beta.1') }.should_not raise_error
      lambda { v('1.0.0.0') }.should raise_error(SemanticVersioning::ParsingError)
    end
  end

  describe 'instance methods' do
    specify { version.major.should == 1 }
    specify { version.minor.should == 2 }
    specify { version.patch.should == 3 }
    specify { version.pre.should == 'pre.1' }
    specify { version.prerelease.should == version.pre }
    specify { version.build.should == 'build.2' }
  end

  describe 'segments' do
    specify do
      version.segments.all? { |s| s.is_a?(SemanticVersioning::Segment) }.should be_true
    end
  end

  describe 'comparisons from semver.org spec 2.0.0-rc.1' do
    specify { v('1.0.0-alpha').should           be < v('1.0.0-alpha.1') }
    specify { v('1.0.0-alpha.1').should         be < v('1.0.0-beta.2') }
    specify { v('1.0.0-beta.2').should          be < v('1.0.0-beta.11') }
    specify { v('1.0.0-beta.11').should         be < v('1.0.0-rc.1') }
    specify { v('1.0.0-rc.1').should            be < v('1.0.0-rc.1+build.1') }
    specify { v('1.0.0-rc.1+build.1').should    be < v('1.0.0') }
    specify { v('1.0.0').should                 be < v('1.0.0+0.3.7') }
    specify { v('1.0.0+0.3.7').should           be < v('1.3.7+build') }
    specify { v('1.3.7+build').should           be < v('1.3.7+build.2.b8f12d7') }
    specify { v('1.3.7+build.2.b8f12d7').should be < v('1.3.7+build.11.e0f985a') }
  end

  describe 'more comparisons' do
    specify { v('1.0.0').should be > v('1.0.0-rc.1+build.1') }
    specify { v('1.0.0-alpha').should == v('1.0.0-alpha') }
  end

  describe '#increment' do
    specify 'major' do
      version.increment(:major)
      version.to_s.should == '2.0.0'
    end
    specify 'minor' do
      version.increment(:minor)
      version.to_s.should == '1.3.0'
    end
    specify 'patch' do
      version.increment(:patch)
      version.to_s.should == '1.2.4'
    end
  end

  describe 'resetting pre and build' do
    specify 'pre' do
      version.pre = 'pre.2'
      version.to_s.should == '1.2.3-pre.2+build.2'
    end
    specify 'build' do
      version.build = 'build.99'
      version.to_s.should == '1.2.3-pre.1+build.99'
    end
  end

end