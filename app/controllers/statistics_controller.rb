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

  def country_summary
    @countries = Country.all
    data = []
    other = {
      registered_users: 0,
      organisations_with_users: 0,
      assessments: {
        completed: 0,
        total: 0
      },
      questionnaire_version: Questionnaire.current.version
    }
    @countries.each { |c|
      completed = c.users_with_completed_assessments.count
      if (completed >= ODMAT::Application::HEATMAP_THRESHOLD)
        data << create_country_summary_data(c, completed)
      else
        other[:registered_users] +=  c.users.count
        other[:organisations_with_users] += c.users_with_organisations.count
        other[:assessments][:completed] += completed
        other[:assessments][:total] += c.assessments.count
      end
    }
    data << create_no_country_summary_data() << create_other_country_summary_data(other)
    respond_to do |format|
      format.json {
        render :json => data
      }
      format.csv {
        send_data create_country_summary_csv(data), content_type: "text/csv; charset=utf-8"
      }
    end
  end
end
