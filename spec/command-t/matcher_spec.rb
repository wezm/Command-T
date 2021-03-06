# Copyright 2010 Wincent Colaiuta. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'command-t/scanner/base'

describe CommandT::Matcher do
  describe 'initialization' do
    it 'should raise an ArgumentError if passed nil' do
      lambda { CommandT::Matcher.new nil }.
        should raise_error(ArgumentError)
    end
  end

  describe 'matches_for method' do
    before :each do
      @scanner = mock(CommandT::Scanner::Base)
    end

    it 'should raise an ArgumentError if passed nil' do
      @matcher = CommandT::Matcher.new @scanner
      lambda { @matcher.matches_for(nil) }.
        should raise_error(ArgumentError)
    end

    it 'should return empty array when source array empty' do
      @scanner.stub(:paths).and_return([])
      @no_paths = CommandT::Matcher.new @scanner
      @no_paths.matches_for('foo').should == []
      @no_paths.matches_for('').should == []
    end

    it 'should return empty array when no matches' do
      @scanner.stub(:paths).and_return(['foo/bar', 'foo/baz', 'bing'])
      @no_matches = CommandT::Matcher.new @scanner
      @no_matches.matches_for('xyz').should == []
    end

    it 'should return matching paths' do
      @scanner.stub(:paths).and_return(['foo/bar', 'foo/baz', 'bing'])
      @foo_paths = CommandT::Matcher.new @scanner
      matches = @foo_paths.matches_for('z')
      matches.map { |m| m.to_s }.should == ['foo/baz']
      matches = @foo_paths.matches_for('bg')
      matches.map { |m| m.to_s }.should == ['bing']
    end

    it 'should perform case-insensitive matching' do
      @scanner.stub(:paths).and_return(['Foo'])
      @path = CommandT::Matcher.new @scanner
      matches = @path.matches_for('f')
      matches.map { |m| m.to_s }.should == ['Foo']
    end
  end
end
