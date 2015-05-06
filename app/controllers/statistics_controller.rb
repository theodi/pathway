class StatisticsController < ApplicationController
  include StatisticsHelper
  
  def index
    @dimensions = Questionnaire.current.dimensions
    @scorer = OrganisationScorer.new

    @all_organisations = @scorer.read_all_organisations
    @dgu_organisations = @scorer.read_dgu_organisations
    
    if current_user && (current_user.organisation.present? && current_user.organisation.parent.present?)
      @parent_organisation = Organisation.find( current_user.organisation.parent )
      @peer_organisations = @scorer.read_group( @parent_organisation )
    end
    
  end
  
  def data
  end

  def all_organisations
    @dimensions = Questionnaire.current.dimensions
    @scorer = OrganisationScorer.new
    @scores = @scorer.read_all_organisations
    respond_to do |format|
      format.json {
        render :json => create_public_scores(@dimensions, @scores)
      }
      format.csv {
        send_data create_csv(@dimensions, @scores), content_type: "text/csv; charset=utf-8"
      }
    end
  end      

  def all_dgu_organisations
    @dimensions = Questionnaire.current.dimensions
    @scorer = OrganisationScorer.new
    @scores = @scorer.read_dgu_organisations
    respond_to do |format|
      format.json {
        render :json => create_public_scores(@dimensions, @scores)
      }
      format.csv {
        send_data create_csv(@dimensions, @scores), content_type: "text/csv; charset=utf-8"
      }
    end

  end      

  def summary
    data = {
      registered_users: User.count,
      organisations: {
        datagovuk: Organisation.dgu.count,
        total: Organisation.count,
        total_with_users: User.organisational_users.count
      },
      assessments: {
        completed: Assessment.completed.count,
        total: Assessment.count
      },
      questionnaire_version: Questionnaire.current.version
    }
    respond_to do |format|
      format.json {
        render :json => data
      }
      format.csv {
        send_data create_summary_csv(data), content_type: "text/csv; charset=utf-8"
      }
    end    
  end
end