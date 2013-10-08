parser grammar gclParser;

options {
  language = Java;
  tokenVocab = gclLex;
}

@header {
  package gclSpecification;
}

rule: ;
