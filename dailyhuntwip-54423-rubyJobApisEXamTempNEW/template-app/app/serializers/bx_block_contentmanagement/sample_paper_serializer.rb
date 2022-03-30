module BxBlockContentmanagement
  class SamplePaperSerializer < BuilderBase::BaseSerializer
    attributes :id, :sample_papers, :created_at, :updated_at

    attribute :sample_papers do |object|
      if object.pdfs.present?
        object.pdfs.map do |pdf|
          pdf.pdf_url if pdf.present?
        end
      else
        []
      end
    end
  end
end
