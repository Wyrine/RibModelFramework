library(testthat)
library(ribModel)

context("Sequence Summary")

ss <- new(SequenceSummary, 
"ATGCTCATTCTCACTGCTGCCTCGTAG"
)

test_that("AA counts for AA", {
	expect_equal(ss$getAACountForAA("M"), 1)
	expect_equal(ss$getAACountForAA("L"), 2)
	expect_equal(ss$getAACountForAA("I"), 1)
	expect_equal(ss$getAACountForAA("T"), 1)
	expect_equal(ss$getAACountForAA("A"), 2)
	expect_equal(ss$getAACountForAA("S"), 1)
	expect_equal(ss$getAACountForAA("X"), 1)
	expect_equal(ss$getAACountForAA("G"), 0)
})

test_that("AA counts for AA Index", {
  expect_equal(ss$getAACountForAAIndex(10), 1)
  expect_equal(ss$getAACountForAAIndex(9), 2)
  expect_equal(ss$getAACountForAAIndex(7), 1)
  expect_equal(ss$getAACountForAAIndex(16), 1)
  expect_equal(ss$getAACountForAAIndex(0), 2)
  expect_equal(ss$getAACountForAAIndex(15), 1)
  expect_equal(ss$getAACountForAAIndex(21), 1)
  expect_equal(ss$getAACountForAAIndex(2), 0)
})

test_that("Codon Counts for Codon", {
  expect_equal(ss$getCodonCountForCodon("ATG"), 1)
  expect_equal(ss$getCodonCountForCodon("CTC"), 2)
  expect_equal(ss$getCodonCountForCodon("ATT"), 1)
  expect_equal(ss$getCodonCountForCodon("ACT"), 1)
  expect_equal(ss$getCodonCountForCodon("GCT"), 1)
  expect_equal(ss$getCodonCountForCodon("GCC"), 1)
  expect_equal(ss$getCodonCountForCodon("TCG"), 1)
  expect_equal(ss$getCodonCountForCodon("TAG"), 1)
  expect_equal(ss$getCodonCountForCodon("AAA"), 0)
})

test_that("Codon Counts for Codon Index", {
  expect_equal(ss$getCodonCountForCodonIndex(29), 1)
  expect_equal(ss$getCodonCountForCodonIndex(24), 2)
  expect_equal(ss$getCodonCountForCodonIndex(20), 1)
  expect_equal(ss$getCodonCountForCodonIndex(51), 1)
  expect_equal(ss$getCodonCountForCodonIndex(3), 1)
  expect_equal(ss$getCodonCountForCodonIndex(1), 1)
  expect_equal(ss$getCodonCountForCodonIndex(46), 1)
  expect_equal(ss$getCodonCountForCodonIndex(62), 1)
  expect_equal(ss$getCodonCountForCodonIndex(2), 0)
})

test_that("RFP Observed for codon", {
  ss$setRFPObserved(4, 35)
  ss$setRFPObserved(16, 45)
  ss$setRFPObserved(54, 2)
  ss$setRFPObserved(45, 0)
  expect_equal(ss$getRFPObservedForCodon("TGC"), 35)
  expect_equal(ss$getRFPObservedForCodon("CAC"), 45)
  expect_equal(ss$getRFPObservedForCodon("GTG"),2)
  expect_equal(ss$getRFPObservedForCodon("TCC"), 0)
})

test_that("RFP Observed test for codon Index", {
  ss$setRFPObserved(0, 45)
  ss$setRFPObserved(1, 52)
  ss$setRFPObserved(2, 63)
  ss$setRFPObserved(60, 23)
  expect_equal(ss$getRFPObservedForCodonIndex(0), 45)
  expect_equal(ss$getRFPObservedForCodonIndex(1), 52)
  expect_equal(ss$getRFPObservedForCodonIndex(2), 63)
  expect_equal(ss$getRFPObservedForCodonIndex(60), 23)
})

test_that("Codon Positions by Codon", {
  expect_equal(ss$getCodonPositionsForCodon("ATG"), c(0))
  expect_equal(ss$getCodonPositionsForCodon("CTC"), c(1,3))
  expect_equal(ss$getCodonPositionsForCodon("ATT"), c(2))
  expect_equal(ss$getCodonPositionsForCodon("ACT"), c(4))
  expect_equal(ss$getCodonPositionsForCodon("GCT"), c(5))
  expect_equal(ss$getCodonPositionsForCodon("GCC"), c(6))
  expect_equal(ss$getCodonPositionsForCodon("TCG"), c(7))
  expect_equal(ss$getCodonPositionsForCodon("TAG"), c(8))
  expect_equal(ss$getCodonPositionsForCodon("GTG"), numeric(0))
})

test_that("Codon Positions", {
  expect_equal(ss$getCodonPositionsForCodonIndex(29), c(0))
  expect_equal(ss$getCodonPositionsForCodonIndex(24), c(1,3))
  expect_equal(ss$getCodonPositionsForCodonIndex(20), c(2))
  expect_equal(ss$getCodonPositionsForCodonIndex(51), c(4))
  expect_equal(ss$getCodonPositionsForCodonIndex(3), c(5))
  expect_equal(ss$getCodonPositionsForCodonIndex(1), c(6))
  expect_equal(ss$getCodonPositionsForCodonIndex(46), c(7))
  expect_equal(ss$getCodonPositionsForCodonIndex(62), c(8))
  expect_equal(ss$getCodonPositionsForCodonIndex(54), numeric(0))
})

test_that("Clear", {
  ss$clear()
  
  # i-1 is because of the difference in indexing from R to C++
  
  for (i in 1:64) {
    expect_equal(ss$getCodonCountForCodonIndex(i-1), 0)
    expect_equal(ss$getRFPObservedForCodonIndex(i-1), 0)
  }
  
  for (i in 1:22) {
    expect_equal(ss$getAACountForAAIndex(i-1), 0)
  }
})

ss$processSequence("ATGCTCATTCTCACTGCTGCCTCGTAG")

test_that("Process Sequence", {
  
  expect_equal(ss$getAACountForAA("I"), 1)
  expect_equal(ss$getAACountForAA("T"), 1)
  expect_equal(ss$getAACountForAAIndex(15), 1)
  expect_equal(ss$getAACountForAAIndex(21), 1)
  expect_equal(ss$getCodonCountForCodon("ATT"), 1)
  expect_equal(ss$getCodonCountForCodon("ACT"), 1)
  expect_equal(ss$getCodonCountForCodon("GCT"), 1)
  expect_equal(ss$getCodonCountForCodon("GCC"), 1)
  expect_equal(ss$getCodonPositionsForCodonIndex(24), c(1,3))
  expect_equal(ss$getCodonPositionsForCodonIndex(20), c(2))
})

test_that("AA to AA index", {
  expect_equal(AAToAAIndex("A"), 0)
  expect_equal(AAToAAIndex("C"), 1)
  expect_equal(AAToAAIndex("D"), 2)
  expect_equal(AAToAAIndex("E"), 3)
  expect_equal(AAToAAIndex("F"), 4)
  expect_equal(AAToAAIndex("G"), 5)
  expect_equal(AAToAAIndex("H"), 6)
  expect_equal(AAToAAIndex("I"), 7)
  expect_equal(AAToAAIndex("K"), 8)
  expect_equal(AAToAAIndex("L"), 9)
  expect_equal(AAToAAIndex("M"), 10)
  expect_equal(AAToAAIndex("N"), 11)
  expect_equal(AAToAAIndex("P"), 12)
  expect_equal(AAToAAIndex("Q"), 13)
  expect_equal(AAToAAIndex("R"), 14)
  expect_equal(AAToAAIndex("S"), 15)
  expect_equal(AAToAAIndex("T"), 16)
  expect_equal(AAToAAIndex("V"), 17)
  expect_equal(AAToAAIndex("W"), 18)
  expect_equal(AAToAAIndex("Y"), 19)
  expect_equal(AAToAAIndex("Z"), 20)
  expect_equal(AAToAAIndex("X"), 21)
})

#Used to test AAToCodonRange, but that is now returned by
#reference and cannot deal with that in R. Since this will
#change with codonTable being completed, the tests have been
#ommitted for the time being.

test_that("AA To Codon", {
  expect_equal(AAToCodon("A", FALSE), c("GCA", "GCC", "GCG", "GCT"))
  expect_equal(AAToCodon("C", FALSE), c("TGC", "TGT"))
  expect_equal(AAToCodon("D", FALSE), c("GAC", "GAT"))
  expect_equal(AAToCodon("E", FALSE), c("GAA", "GAG"))
  expect_equal(AAToCodon("F", FALSE), c("TTC", "TTT"))
  expect_equal(AAToCodon("G", FALSE), c("GGA", "GGC", "GGG", "GGT"))
  expect_equal(AAToCodon("H", FALSE), c("CAC", "CAT"))
  expect_equal(AAToCodon("I", FALSE), c("ATA", "ATC", "ATT"))
  expect_equal(AAToCodon("K", FALSE), c("AAA", "AAG"))
  expect_equal(AAToCodon("L", FALSE), c("CTA", "CTC", "CTG", "CTT", "TTA", "TTG"))
  expect_equal(AAToCodon("M", FALSE), c("ATG"))
  expect_equal(AAToCodon("N", FALSE), c("AAC", "AAT"))
  expect_equal(AAToCodon("P", FALSE), c("CCA", "CCC", "CCG", "CCT"))
  expect_equal(AAToCodon("Q", FALSE), c("CAA", "CAG"))
  expect_equal(AAToCodon("R", FALSE), c("AGA", "AGG", "CGA", "CGC", "CGG", "CGT"))
  expect_equal(AAToCodon("S", FALSE), c("TCA", "TCC", "TCG", "TCT"))
  expect_equal(AAToCodon("T", FALSE), c("ACA", "ACC", "ACG", "ACT"))
  expect_equal(AAToCodon("V", FALSE), c("GTA", "GTC", "GTG", "GTT"))
  expect_equal(AAToCodon("W", FALSE), c("TGG"))
  expect_equal(AAToCodon("Y", FALSE), c("TAC", "TAT"))
  expect_equal(AAToCodon("Z", FALSE), c("AGC", "AGT"))
  expect_equal(AAToCodon("X", FALSE), c("TAA", "TAG", "TGA"))
  expect_equal(AAToCodon("A", TRUE), c("GCA", "GCC", "GCG"))
  expect_equal(AAToCodon("C", TRUE), c("TGC"))
  expect_equal(AAToCodon("D", TRUE), c("GAC"))
  expect_equal(AAToCodon("E", TRUE), c("GAA"))
  expect_equal(AAToCodon("F", TRUE), c("TTC"))
  expect_equal(AAToCodon("G", TRUE), c("GGA", "GGC", "GGG"))
  expect_equal(AAToCodon("H", TRUE), c("CAC"))
  expect_equal(AAToCodon("I", TRUE), c("ATA", "ATC"))
  expect_equal(AAToCodon("K", TRUE), c("AAA"))
  expect_equal(AAToCodon("L", TRUE), c("CTA", "CTC", "CTG", "CTT", "TTA"))
  expect_equal(AAToCodon("M", TRUE), character(0))
  expect_equal(AAToCodon("N", TRUE), c("AAC"))
  expect_equal(AAToCodon("P", TRUE), c("CCA", "CCC", "CCG"))
  expect_equal(AAToCodon("Q", TRUE), c("CAA"))
  expect_equal(AAToCodon("R", TRUE), c("AGA", "AGG", "CGA", "CGC", "CGG"))
  expect_equal(AAToCodon("S", TRUE), c("TCA", "TCC", "TCG"))
  expect_equal(AAToCodon("T", TRUE), c("ACA", "ACC", "ACG"))
  expect_equal(AAToCodon("V", TRUE), c("GTA", "GTC", "GTG"))
  expect_equal(AAToCodon("W", TRUE), character(0))
  expect_equal(AAToCodon("Y", TRUE), c("TAC"))
  expect_equal(AAToCodon("Z", TRUE), c("AGC"))
  expect_equal(AAToCodon("X", TRUE), character(0))
})

test_that("Codon To AA", {
  expect_equal(codonToAA("GCA"), "A") 
  expect_equal(codonToAA("GCC"), "A")
  expect_equal(codonToAA("GCG"), "A")
  expect_equal(codonToAA("GCT"), "A")
  expect_equal(codonToAA("TGC"), "C")
  expect_equal(codonToAA("TGT"), "C")
  expect_equal(codonToAA("GAC"), "D")
  expect_equal(codonToAA("GAT"), "D")
  expect_equal(codonToAA("GAA"), "E")
  expect_equal(codonToAA("GAG"), "E")
  expect_equal(codonToAA("TTC"), "F")
  expect_equal(codonToAA("TTT"), "F")
  expect_equal(codonToAA("GGA"), "G")
  expect_equal(codonToAA("GGC"), "G")
  expect_equal(codonToAA("GGG"), "G")
  expect_equal(codonToAA("GGT"), "G")
  expect_equal(codonToAA("CAC"), "H")
  expect_equal(codonToAA("CAT"), "H")
  expect_equal(codonToAA("ATA"), "I")
  expect_equal(codonToAA("ATC"), "I")
  expect_equal(codonToAA("ATT"), "I")
  expect_equal(codonToAA("AAA"), "K")
  expect_equal(codonToAA("AAG"), "K")
  expect_equal(codonToAA("CTA"), "L")
  expect_equal(codonToAA("CTC"), "L")
  expect_equal(codonToAA("CTG"), "L")
  expect_equal(codonToAA("CTT"), "L")
  expect_equal(codonToAA("TTA"), "L")
  expect_equal(codonToAA("TTG"), "L")
  expect_equal(codonToAA("ATG"), "M")
  expect_equal(codonToAA("AAC"), "N")
  expect_equal(codonToAA("AAT"), "N")
  expect_equal(codonToAA("CCA"), "P")
  expect_equal(codonToAA("CCC"), "P")
  expect_equal(codonToAA("CCG"), "P")
  expect_equal(codonToAA("CCT"), "P")
  expect_equal(codonToAA("CAA"), "Q")
  expect_equal(codonToAA("CAG"), "Q")
  expect_equal(codonToAA("AGA"), "R")
  expect_equal(codonToAA("AGG"), "R")
  expect_equal(codonToAA("CGA"), "R")
  expect_equal(codonToAA("CGC"), "R")
  expect_equal(codonToAA("CGG"), "R")
  expect_equal(codonToAA("CGT"), "R")
  expect_equal(codonToAA("TCA"), "S")
  expect_equal(codonToAA("TCC"), "S")
  expect_equal(codonToAA("TCG"), "S")
  expect_equal(codonToAA("TCT"), "S")
  expect_equal(codonToAA("ACA"), "T")
  expect_equal(codonToAA("ACC"), "T")
  expect_equal(codonToAA("ACG"), "T")
  expect_equal(codonToAA("ACT"), "T")
  expect_equal(codonToAA("GTA"), "V")
  expect_equal(codonToAA("GTC"), "V")
  expect_equal(codonToAA("GTG"), "V")
  expect_equal(codonToAA("GTT"), "V")
  expect_equal(codonToAA("TGG"), "W")
  expect_equal(codonToAA("TAC"), "Y")
  expect_equal(codonToAA("TAT"), "Y")
  expect_equal(codonToAA("AGC"), "Z")
  expect_equal(codonToAA("AGT"), "Z")
  expect_equal(codonToAA("TAA"), "X")
  expect_equal(codonToAA("TAG"), "X")
  expect_equal(codonToAA("TGA"), "X")
})

test_that("Codon To Index", {
  expect_equal(codonToIndex("GCA", FALSE), 0) 
  expect_equal(codonToIndex("GCC", FALSE), 1)
  expect_equal(codonToIndex("GCG", FALSE), 2)
  expect_equal(codonToIndex("GCT", FALSE), 3)
  expect_equal(codonToIndex("TGC", FALSE), 4)
  expect_equal(codonToIndex("TGT", FALSE), 5)
  expect_equal(codonToIndex("GAC", FALSE), 6)
  expect_equal(codonToIndex("GAT", FALSE), 7)
  expect_equal(codonToIndex("GAA", FALSE), 8)
  expect_equal(codonToIndex("GAG", FALSE), 9)
  expect_equal(codonToIndex("TTC", FALSE), 10)
  expect_equal(codonToIndex("TTT", FALSE), 11)
  expect_equal(codonToIndex("GGA", FALSE), 12)
  expect_equal(codonToIndex("GGC", FALSE), 13)
  expect_equal(codonToIndex("GGG", FALSE), 14)
  expect_equal(codonToIndex("GGT", FALSE), 15)
  expect_equal(codonToIndex("CAC", FALSE), 16)
  expect_equal(codonToIndex("CAT", FALSE), 17)
  expect_equal(codonToIndex("ATA", FALSE), 18)
  expect_equal(codonToIndex("ATC", FALSE), 19)
  expect_equal(codonToIndex("ATT", FALSE), 20)
  expect_equal(codonToIndex("AAA", FALSE), 21)
  expect_equal(codonToIndex("AAG", FALSE), 22)
  expect_equal(codonToIndex("CTA", FALSE), 23)
  expect_equal(codonToIndex("CTC", FALSE), 24)
  expect_equal(codonToIndex("CTG", FALSE), 25)
  expect_equal(codonToIndex("CTT", FALSE), 26)
  expect_equal(codonToIndex("TTA", FALSE), 27)
  expect_equal(codonToIndex("TTG", FALSE), 28)
  expect_equal(codonToIndex("ATG", FALSE), 29)
  expect_equal(codonToIndex("AAC", FALSE), 30)
  expect_equal(codonToIndex("AAT", FALSE), 31)
  expect_equal(codonToIndex("CCA", FALSE), 32)
  expect_equal(codonToIndex("CCC", FALSE), 33)
  expect_equal(codonToIndex("CCG", FALSE), 34)
  expect_equal(codonToIndex("CCT", FALSE), 35)
  expect_equal(codonToIndex("CAA", FALSE), 36)
  expect_equal(codonToIndex("CAG", FALSE), 37)
  expect_equal(codonToIndex("AGA", FALSE), 38)
  expect_equal(codonToIndex("AGG", FALSE), 39)
  expect_equal(codonToIndex("CGA", FALSE), 40)
  expect_equal(codonToIndex("CGC", FALSE), 41)
  expect_equal(codonToIndex("CGG", FALSE), 42)
  expect_equal(codonToIndex("CGT", FALSE), 43)
  expect_equal(codonToIndex("TCA", FALSE), 44)
  expect_equal(codonToIndex("TCC", FALSE), 45)
  expect_equal(codonToIndex("TCG", FALSE), 46)
  expect_equal(codonToIndex("TCT", FALSE), 47)
  expect_equal(codonToIndex("ACA", FALSE), 48)
  expect_equal(codonToIndex("ACC", FALSE), 49)
  expect_equal(codonToIndex("ACG", FALSE), 50)
  expect_equal(codonToIndex("ACT", FALSE), 51)
  expect_equal(codonToIndex("GTA", FALSE), 52)
  expect_equal(codonToIndex("GTC", FALSE), 53)
  expect_equal(codonToIndex("GTG", FALSE), 54)
  expect_equal(codonToIndex("GTT", FALSE), 55)
  expect_equal(codonToIndex("TGG", FALSE), 56)
  expect_equal(codonToIndex("TAC", FALSE), 57)
  expect_equal(codonToIndex("TAT", FALSE), 58)
  expect_equal(codonToIndex("AGC", FALSE), 59)
  expect_equal(codonToIndex("AGT", FALSE), 60)
  expect_equal(codonToIndex("TAA", FALSE), 61)
  expect_equal(codonToIndex("TAG", FALSE), 62)
  expect_equal(codonToIndex("TGA", FALSE), 63)
  expect_equal(codonToIndex("GCA", TRUE), 0) 
  expect_equal(codonToIndex("GCC", TRUE), 1)
  expect_equal(codonToIndex("GCG", TRUE), 2)
  expect_equal(codonToIndex("TGC", TRUE), 3)
  expect_equal(codonToIndex("GAC", TRUE), 4)
  expect_equal(codonToIndex("GAA", TRUE), 5)
  expect_equal(codonToIndex("TTC", TRUE), 6)
  expect_equal(codonToIndex("GGA", TRUE), 7)
  expect_equal(codonToIndex("GGC", TRUE), 8)
  expect_equal(codonToIndex("GGG", TRUE), 9)
  expect_equal(codonToIndex("CAC", TRUE), 10)
  expect_equal(codonToIndex("ATA", TRUE), 11)
  expect_equal(codonToIndex("ATC", TRUE), 12)
  expect_equal(codonToIndex("AAA", TRUE), 13)
  expect_equal(codonToIndex("CTA", TRUE), 14)
  expect_equal(codonToIndex("CTC", TRUE), 15)
  expect_equal(codonToIndex("CTG", TRUE), 16)
  expect_equal(codonToIndex("CTT", TRUE), 17)
  expect_equal(codonToIndex("TTA", TRUE), 18)
  expect_equal(codonToIndex("AAC", TRUE), 19)
  expect_equal(codonToIndex("CCA", TRUE), 20)
  expect_equal(codonToIndex("CCC", TRUE), 21)
  expect_equal(codonToIndex("CCG", TRUE), 22)
  expect_equal(codonToIndex("CAA", TRUE), 23)
  expect_equal(codonToIndex("AGA", TRUE), 24)
  expect_equal(codonToIndex("AGG", TRUE), 25)
  expect_equal(codonToIndex("CGA", TRUE), 26)
  expect_equal(codonToIndex("CGC", TRUE), 27)
  expect_equal(codonToIndex("CGG", TRUE), 28)
  expect_equal(codonToIndex("TCA", TRUE), 29)
  expect_equal(codonToIndex("TCC", TRUE), 30)
  expect_equal(codonToIndex("TCG", TRUE), 31)
  expect_equal(codonToIndex("ACA", TRUE), 32)
  expect_equal(codonToIndex("ACC", TRUE), 33)
  expect_equal(codonToIndex("ACG", TRUE), 34)
  expect_equal(codonToIndex("GTA", TRUE), 35)
  expect_equal(codonToIndex("GTC", TRUE), 36)
  expect_equal(codonToIndex("GTG", TRUE), 37)
  expect_equal(codonToIndex("TAC", TRUE), 38)
  expect_equal(codonToIndex("AGC", TRUE), 39)
})

test_that("Codon to AA Index", {
  expect_equal(codonToAAIndex("GCA"), 0) 
  expect_equal(codonToAAIndex("GCC"), 0)
  expect_equal(codonToAAIndex("GCG"), 0)
  expect_equal(codonToAAIndex("GCT"), 0)
  expect_equal(codonToAAIndex("TGC"), 1)
  expect_equal(codonToAAIndex("TGT"), 1)
  expect_equal(codonToAAIndex("GAC"), 2)
  expect_equal(codonToAAIndex("GAT"), 2)
  expect_equal(codonToAAIndex("GAA"), 3)
  expect_equal(codonToAAIndex("GAG"), 3)
  expect_equal(codonToAAIndex("TTC"), 4)
  expect_equal(codonToAAIndex("TTT"), 4)
  expect_equal(codonToAAIndex("GGA"), 5)
  expect_equal(codonToAAIndex("GGC"), 5)
  expect_equal(codonToAAIndex("GGG"), 5)
  expect_equal(codonToAAIndex("GGT"), 5)
  expect_equal(codonToAAIndex("CAC"), 6)
  expect_equal(codonToAAIndex("CAT"), 6)
  expect_equal(codonToAAIndex("ATA"), 7)
  expect_equal(codonToAAIndex("ATC"), 7)
  expect_equal(codonToAAIndex("ATT"), 7)
  expect_equal(codonToAAIndex("AAA"), 8)
  expect_equal(codonToAAIndex("AAG"), 8)
  expect_equal(codonToAAIndex("CTA"), 9)
  expect_equal(codonToAAIndex("CTC"), 9)
  expect_equal(codonToAAIndex("CTG"), 9)
  expect_equal(codonToAAIndex("CTT"), 9)
  expect_equal(codonToAAIndex("TTA"), 9)
  expect_equal(codonToAAIndex("TTG"), 9)
  expect_equal(codonToAAIndex("ATG"), 10)
  expect_equal(codonToAAIndex("AAC"), 11)
  expect_equal(codonToAAIndex("AAT"), 11)
  expect_equal(codonToAAIndex("CCA"), 12)
  expect_equal(codonToAAIndex("CCC"), 12)
  expect_equal(codonToAAIndex("CCG"), 12)
  expect_equal(codonToAAIndex("CCT"), 12)
  expect_equal(codonToAAIndex("CAA"), 13)
  expect_equal(codonToAAIndex("CAG"), 13)
  expect_equal(codonToAAIndex("AGA"), 14)
  expect_equal(codonToAAIndex("AGG"), 14)
  expect_equal(codonToAAIndex("CGA"), 14)
  expect_equal(codonToAAIndex("CGC"), 14)
  expect_equal(codonToAAIndex("CGG"), 14)
  expect_equal(codonToAAIndex("CGT"), 14)
  expect_equal(codonToAAIndex("TCA"), 15)
  expect_equal(codonToAAIndex("TCC"), 15)
  expect_equal(codonToAAIndex("TCG"), 15)
  expect_equal(codonToAAIndex("TCT"), 15)
  expect_equal(codonToAAIndex("ACA"), 16)
  expect_equal(codonToAAIndex("ACC"), 16)
  expect_equal(codonToAAIndex("ACG"), 16)
  expect_equal(codonToAAIndex("ACT"), 16)
  expect_equal(codonToAAIndex("GTA"), 17)
  expect_equal(codonToAAIndex("GTC"), 17)
  expect_equal(codonToAAIndex("GTG"), 17)
  expect_equal(codonToAAIndex("GTT"), 17)
  expect_equal(codonToAAIndex("TGG"), 18)
  expect_equal(codonToAAIndex("TAC"), 19)
  expect_equal(codonToAAIndex("TAT"), 19)
  expect_equal(codonToAAIndex("AGC"), 20)
  expect_equal(codonToAAIndex("AGT"), 20)
  expect_equal(codonToAAIndex("TAA"), 21)
  expect_equal(codonToAAIndex("TAG"), 21)
  expect_equal(codonToAAIndex("TGA"), 21)
})

test_that("Index to AA", {
  expect_equal(indexToAA(0),"A")
  expect_equal(indexToAA(1),"C")
  expect_equal(indexToAA(2),"D")
  expect_equal(indexToAA(3),"E")
  expect_equal(indexToAA(4),"F")
  expect_equal(indexToAA(5),"G")
  expect_equal(indexToAA(6),"H")
  expect_equal(indexToAA(7),"I")
  expect_equal(indexToAA(8),"K")
  expect_equal(indexToAA(9),"L")
  expect_equal(indexToAA(10),"M")
  expect_equal(indexToAA(11),"N")
  expect_equal(indexToAA(12),"P")
  expect_equal(indexToAA(13),"Q")
  expect_equal(indexToAA(14),"R")
  expect_equal(indexToAA(15),"S")
  expect_equal(indexToAA(16),"T")
  expect_equal(indexToAA(17),"V")
  expect_equal(indexToAA(18),"W")
  expect_equal(indexToAA(19),"Y")
  expect_equal(indexToAA(20),"Z")
  expect_equal(indexToAA(21),"X")
})

test_that("Index to Codon", {
  expect_equal(indexToCodon(0, FALSE), "GCA")
  expect_equal(indexToCodon(1, FALSE), "GCC")
  expect_equal(indexToCodon(2, FALSE), "GCG")
  expect_equal(indexToCodon(3, FALSE), "GCT")
  expect_equal(indexToCodon(4, FALSE), "TGC")
  expect_equal(indexToCodon(5, FALSE), "TGT")
  expect_equal(indexToCodon(6, FALSE), "GAC")
  expect_equal(indexToCodon(7, FALSE), "GAT")
  expect_equal(indexToCodon(8, FALSE), "GAA")
  expect_equal(indexToCodon(9, FALSE), "GAG")
  expect_equal(indexToCodon(10, FALSE), "TTC")
  expect_equal(indexToCodon(11, FALSE), "TTT")
  expect_equal(indexToCodon(12, FALSE), "GGA")
  expect_equal(indexToCodon(13, FALSE), "GGC")
  expect_equal(indexToCodon(14, FALSE), "GGG")
  expect_equal(indexToCodon(15, FALSE), "GGT")
  expect_equal(indexToCodon(16, FALSE), "CAC")
  expect_equal(indexToCodon(17, FALSE), "CAT")
  expect_equal(indexToCodon(18, FALSE), "ATA")
  expect_equal(indexToCodon(19, FALSE), "ATC")
  expect_equal(indexToCodon(20, FALSE), "ATT")
  expect_equal(indexToCodon(21, FALSE), "AAA")
  expect_equal(indexToCodon(22, FALSE), "AAG")
  expect_equal(indexToCodon(23, FALSE), "CTA")
  expect_equal(indexToCodon(24, FALSE), "CTC")
  expect_equal(indexToCodon(25, FALSE), "CTG")
  expect_equal(indexToCodon(26, FALSE), "CTT")
  expect_equal(indexToCodon(27, FALSE), "TTA")
  expect_equal(indexToCodon(28, FALSE), "TTG")
  expect_equal(indexToCodon(29, FALSE), "ATG")
  expect_equal(indexToCodon(30, FALSE), "AAC")
  expect_equal(indexToCodon(31, FALSE), "AAT")
  expect_equal(indexToCodon(32, FALSE), "CCA")
  expect_equal(indexToCodon(33, FALSE), "CCC")
  expect_equal(indexToCodon(34, FALSE), "CCG")
  expect_equal(indexToCodon(35, FALSE), "CCT")
  expect_equal(indexToCodon(36, FALSE), "CAA")
  expect_equal(indexToCodon(37, FALSE), "CAG")
  expect_equal(indexToCodon(38, FALSE), "AGA")
  expect_equal(indexToCodon(39, FALSE), "AGG")
  expect_equal(indexToCodon(40, FALSE), "CGA")
  expect_equal(indexToCodon(41, FALSE), "CGC")
  expect_equal(indexToCodon(42, FALSE), "CGG")
  expect_equal(indexToCodon(43, FALSE), "CGT")
  expect_equal(indexToCodon(44, FALSE), "TCA")
  expect_equal(indexToCodon(45, FALSE), "TCC")
  expect_equal(indexToCodon(46, FALSE), "TCG")
  expect_equal(indexToCodon(47, FALSE), "TCT")
  expect_equal(indexToCodon(48, FALSE), "ACA")
  expect_equal(indexToCodon(49, FALSE), "ACC")
  expect_equal(indexToCodon(50, FALSE), "ACG")
  expect_equal(indexToCodon(51, FALSE), "ACT")
  expect_equal(indexToCodon(52, FALSE), "GTA")
  expect_equal(indexToCodon(53, FALSE), "GTC")
  expect_equal(indexToCodon(54, FALSE), "GTG")
  expect_equal(indexToCodon(55, FALSE), "GTT")
  expect_equal(indexToCodon(56, FALSE), "TGG")
  expect_equal(indexToCodon(57, FALSE), "TAC")
  expect_equal(indexToCodon(58, FALSE), "TAT")
  expect_equal(indexToCodon(59, FALSE), "AGC")
  expect_equal(indexToCodon(60, FALSE), "AGT")
  expect_equal(indexToCodon(61, FALSE), "TAA")
  expect_equal(indexToCodon(62, FALSE), "TAG")
  expect_equal(indexToCodon(63, FALSE), "TGA")
  expect_equal(indexToCodon(0, TRUE), "GCA")
  expect_equal(indexToCodon(1, TRUE), "GCC")
  expect_equal(indexToCodon(2, TRUE), "GCG")
  expect_equal(indexToCodon(3, TRUE), "TGC")
  expect_equal(indexToCodon(4, TRUE), "GAC")
  expect_equal(indexToCodon(5, TRUE), "GAA")
  expect_equal(indexToCodon(6, TRUE), "TTC")
  expect_equal(indexToCodon(7, TRUE), "GGA")
  expect_equal(indexToCodon(8, TRUE), "GGC")
  expect_equal(indexToCodon(9, TRUE), "GGG")
  expect_equal(indexToCodon(10, TRUE), "CAC")
  expect_equal(indexToCodon(11, TRUE), "ATA")
  expect_equal(indexToCodon(12, TRUE), "ATC")
  expect_equal(indexToCodon(13, TRUE), "AAA")
  expect_equal(indexToCodon(14, TRUE), "CTA")
  expect_equal(indexToCodon(15, TRUE), "CTC")
  expect_equal(indexToCodon(16, TRUE), "CTG")
  expect_equal(indexToCodon(17, TRUE), "CTT")
  expect_equal(indexToCodon(18, TRUE), "TTA")
  expect_equal(indexToCodon(19, TRUE), "AAC")
  expect_equal(indexToCodon(20, TRUE), "CCA")
  expect_equal(indexToCodon(21, TRUE), "CCC")
  expect_equal(indexToCodon(22, TRUE), "CCG")
  expect_equal(indexToCodon(23, TRUE), "CAA")
  expect_equal(indexToCodon(24, TRUE), "AGA")
  expect_equal(indexToCodon(25, TRUE), "AGG")
  expect_equal(indexToCodon(26, TRUE), "CGA")
  expect_equal(indexToCodon(27, TRUE), "CGC")
  expect_equal(indexToCodon(28, TRUE), "CGG")
  expect_equal(indexToCodon(29, TRUE), "TCA")
  expect_equal(indexToCodon(30, TRUE), "TCC")
  expect_equal(indexToCodon(31, TRUE), "TCG")
  expect_equal(indexToCodon(32, TRUE), "ACA")
  expect_equal(indexToCodon(33, TRUE), "ACC")
  expect_equal(indexToCodon(34, TRUE), "ACG")
  expect_equal(indexToCodon(35, TRUE), "GTA")
  expect_equal(indexToCodon(36, TRUE), "GTC")
  expect_equal(indexToCodon(37, TRUE), "GTG")
  expect_equal(indexToCodon(38, TRUE), "TAC")
  expect_equal(indexToCodon(39, TRUE), "AGC")
})

test_that("Num Codons for AA", {
  expect_equal(GetNumCodonsForAA("A", FALSE), 4)
  expect_equal(GetNumCodonsForAA("C", FALSE), 2)
  expect_equal(GetNumCodonsForAA("D", FALSE), 2) 
  expect_equal(GetNumCodonsForAA("E", FALSE), 2)
  expect_equal(GetNumCodonsForAA("F", FALSE), 2)
  expect_equal(GetNumCodonsForAA("G", FALSE), 4)
  expect_equal(GetNumCodonsForAA("H", FALSE), 2)
  expect_equal(GetNumCodonsForAA("I", FALSE), 3)
  expect_equal(GetNumCodonsForAA("K", FALSE), 2)
  expect_equal(GetNumCodonsForAA("L", FALSE), 6)
  expect_equal(GetNumCodonsForAA("M", FALSE), 1)
  expect_equal(GetNumCodonsForAA("N", FALSE), 2)
  expect_equal(GetNumCodonsForAA("P", FALSE), 4)
  expect_equal(GetNumCodonsForAA("Q", FALSE), 2)
  expect_equal(GetNumCodonsForAA("R", FALSE), 6)
  expect_equal(GetNumCodonsForAA("S", FALSE), 4)
  expect_equal(GetNumCodonsForAA("T", FALSE), 4)
  expect_equal(GetNumCodonsForAA("V", FALSE), 4)
  expect_equal(GetNumCodonsForAA("W", FALSE), 1)
  expect_equal(GetNumCodonsForAA("Y", FALSE), 2)
  expect_equal(GetNumCodonsForAA("Z", FALSE), 2)
  expect_equal(GetNumCodonsForAA("X", FALSE), 3)
  expect_equal(GetNumCodonsForAA("A", TRUE), 3)
  expect_equal(GetNumCodonsForAA("C", TRUE), 1)
  expect_equal(GetNumCodonsForAA("D", TRUE), 1)
  expect_equal(GetNumCodonsForAA("E", TRUE), 1)
  expect_equal(GetNumCodonsForAA("F", TRUE), 1)
  expect_equal(GetNumCodonsForAA("G", TRUE), 3)
  expect_equal(GetNumCodonsForAA("H", TRUE), 1)
  expect_equal(GetNumCodonsForAA("I", TRUE), 2)
  expect_equal(GetNumCodonsForAA("K", TRUE), 1)
  expect_equal(GetNumCodonsForAA("L", TRUE), 5)
  expect_equal(GetNumCodonsForAA("M", TRUE), 0)
  expect_equal(GetNumCodonsForAA("N", TRUE), 1)
  expect_equal(GetNumCodonsForAA("P", TRUE), 3)
  expect_equal(GetNumCodonsForAA("Q", TRUE), 1)
  expect_equal(GetNumCodonsForAA("R", TRUE), 5)
  expect_equal(GetNumCodonsForAA("S", TRUE), 3)
  expect_equal(GetNumCodonsForAA("T", TRUE), 3)
  expect_equal(GetNumCodonsForAA("V", TRUE), 3)
  expect_equal(GetNumCodonsForAA("W", TRUE), 0)
  expect_equal(GetNumCodonsForAA("Y", TRUE), 1)
  expect_equal(GetNumCodonsForAA("Z", TRUE), 1)
  expect_equal(GetNumCodonsForAA("X", TRUE), 2)
})

test_that("Complement Nucleotide", {
  expect_equal(complimentNucleotide("A"), "T")
  expect_equal(complimentNucleotide("T"), "A")
  expect_equal(complimentNucleotide("C"), "G")
  expect_equal(complimentNucleotide("G"), "C")
  expect_equal(complimentNucleotide("Q"), "C")
})

test_that("Amino Acid Vector", {
  expect_equal(aminoAcids(), c(
  "A",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "K",
  "L",
  "M",
  "N",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "V",
  "W",
  "Y",
  "Z",
  "X"))
})

test_that("Codon Vector", {
  expect_equal(codons(), c(
    "GCA", 
    "GCC",
    "GCG",
    "GCT",
    "TGC",
    "TGT",
    "GAC",
    "GAT",
    "GAA",
    "GAG",
    "TTC",
    "TTT",
    "GGA",
    "GGC",
    "GGG",
    "GGT",
    "CAC",
    "CAT",
    "ATA",
    "ATC",
    "ATT",
    "AAA",
    "AAG",
    "CTA",
    "CTC",
    "CTG",
    "CTT",
    "TTA",
    "TTG",
    "ATG",
    "AAC",
    "AAT",
    "CCA",
    "CCC",
    "CCG",
    "CCT",
    "CAA",
    "CAG",
    "AGA",
    "AGG",
    "CGA",
    "CGC",
    "CGG",
    "CGT",
    "TCA",
    "TCC",
    "TCG",
    "TCT",
    "ACA",
    "ACC",
    "ACG",
    "ACT",
    "GTA",
    "GTC",
    "GTG",
    "GTT",
    "TGG",
    "TAC",
    "TAT",
    "AGC",
    "AGT",
    "TAA",
    "TAG",
    "TGA"
  ))
})