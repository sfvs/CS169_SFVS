require 'spec_helper'

describe Answers do
  make_question_answer_tree
  
  describe "answer functions" do
    it "tells me what answer led to the input question" do
      Answers.get_answer_leading_to(@q1).should == nil
      Answers.get_answer_leading_to(@q2).should == @a1a
    end

    it "tells me the answers to my question" do
      (Answers.get_answer_from(@q2).to_a.include? @a2).should be_true
      answers = Answers.get_answer_from(@q1).to_a
      (answers.include?(@a1a)).should be_true
      (answers.include? @a1b).should be_true
      (answers.include? @a2).should be_false
    end

    it "tells me if my answer is the last answer in the tree" do
      @a1a.is_last_answer?.should be_false
      @a1b.is_last_answer?.should be_true
      @a2.is_last_answer?.should be_true
    end

  end
end
