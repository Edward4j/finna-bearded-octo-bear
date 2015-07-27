require "rails_helper"

shared_examples "voted" do
  sign_in_user

  let(:voteable_name) { described_class.controller_name.singularize.underscore }
  let(:voteable) { create(voteable_name) }

  describe "POST #like" do
    context "non-owner voteable" do

      describe "vote for voteable" do
        it "change count vote" do
          expect{ post :like, id: voteable, format: :json }.to change(voteable.votes, :count).by(1)
        end

        it "like" do
          post :like, id: voteable, format: :json
          expect(assigns(:vote).like).to eq 1
        end

        it "render json success" do
          post :like, id: voteable, format: :json
          expect(response).to be_success
        end
      end

      describe "non-vote for voteable" do
        let!(:vote) { create(:vote, voteable: voteable, user: @user) }

        it "not-change count if user vote for this voteable" do
          expect{ post :like, id: voteable, format: :json }.to_not change(voteable.votes, :count)
        end

        it "render json unprocessable entity" do
          post :like, id: voteable, format: :json
          expect(response.status).to eq(422)
        end
      end
    end

    context "owner voteable" do
      let(:voteable_owner) { create(voteable_name, user: @user) }

      it "not change count vote" do
        expect{ post :like, id: voteable_owner, format: :json }.to_not change(voteable.votes, :count)
      end

      it "redirect to root path" do
        post :like, id: voteable_owner, format: :json
        expect(response).to redirect_to root_path
      end
    end


  end


  describe "POST #dislike" do
    context "non-owner voteable" do

      describe "vote for voteable" do
        it "change count vote" do
          expect{ post :dislike, id: voteable, format: :json }.to change(voteable.votes, :count).by(1)
        end

        it "dislike" do
          post :dislike, id: voteable, format: :json
          expect(assigns(:vote).like).to eq -1
        end

        it "render json success" do
          post :dislike, id: voteable, format: :json
          expect(response).to be_success
        end
      end

      describe "non-vote for voteable" do
        let!(:vote) { create(:vote, voteable: voteable, user: @user) }

        it "not-change count if user vote for this voteable" do
          expect{ post :dislike, id: voteable, format: :json }.to_not change(voteable.votes, :count)
        end

        it "render json unprocessable entity" do
          post :dislike, id: voteable, format: :json
          expect(response.status).to eq(422)
        end
      end

    end

    context "owner voteable" do
      let(:voteable_owner) { create(voteable_name, user: @user) }

      it "not change count vote" do
        expect{ post :dislike, id: voteable_owner, format: :json }.to_not change(voteable.votes, :count)
      end

      it "redirect to root path" do
        post :dislike, id: voteable_owner, format: :json
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE #cancel_vote" do
    sign_in_user

    context "owner vote" do
      let!(:vote) { create(:vote, voteable: voteable, user: @user) }

      it "not-change count vote" do
        expect{ delete :cancel_vote, id: voteable , format: :json }.to change(voteable.votes, :count).by(-1)
      end

      it "render json" do
        delete :cancel_vote, id: voteable , format: :json
        expect(response).to be_success
      end
    end

    context "non-owner vote" do
      let!(:vote) { create(:vote, voteable: voteable) }

      it "change count vote" do
        expect{ delete :cancel_vote, id: voteable , format: :json }.to_not change(voteable.votes, :count)
      end

      it "redirect root path" do
        delete :cancel_vote, id: voteable , format: :json
        expect(response.status).to eq(422)
      end
    end

  end
end