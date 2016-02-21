class InvalidCodonError < StandardError; end

class Translation
  PROTEIN = {
    'AUG' => 'Methionine',
    %w(UUU UUC) => 'Phenylalanine',
    %w(UUA UUG) => 'Leucine',
    %w(UCU UCC UCA UCG) => 'Serine',
    %w(UAU UAC) => 'Tyrosine',
    %w(UGU UGC) => 'Cysteine',
    'UGG' => 'Tryptophan',
    %w(UAA UAG UGA) => 'STOP'
  }

  def self.of_codon(codon)
    PROTEIN.each do |codons, protein|
      return protein if codons.include?(codon)
    end
    raise InvalidCodonError
  end

  def self.of_rna(strand)
    proteins = []
    strand.scan(/.../).each do |codon|
      protein = of_codon(codon)
      break if protein == 'STOP'
      proteins << protein
    end
    proteins
  end
end
