" Vim syntax file
" Language: Odin
" Maintainer: Tyler Erickson
" Latest Revision: 16 Aug 2017

if exists("b:current_syntax")
    finish
endif

" Keywords
syn keyword odinKeyword import do for while in defer match return using import_load foreign foreign_library foreign_system_library const fallthrough break continue asm yield await push_allocator push_context vector static dynamic atomic
syn keyword odinConditional if else when
syn keyword odinLabel case

" Types

" Keywords take precedence over other matches. For now, this works to get around it.
" syn keyword odinBuiltinType int i8 i16 i32 i64 i128 uint u8 u16 u32 u64 u128 f32 f64 rawptr string byte rune proc struct union any type
syn match odinBuiltinType "\W\@<=\(i\(nt\|8\|16\|32\|64\|128\)\|uint\|u\(8\|16\|32\|64\|128\)\|f\(32\|64\)\|rawptr\|string\|byte\|rune\|struct\|union\|any\|type\)\W\@="

syn match odinTypeAssignment contained "\^\=\(\[\]\)\=\(\.\{2,3}\)\=\^\=\$\=\([a-zA-Z_]\+\.\)\=[a-zA-Z_]\w*\(\/\^\=\(\[\]\)\=\(\.\{2,3}\)\=\^\=\$\=\([a-zA-Z_]\+\.\)\=[a-zA-Z_]\w*\)\=" contains=odinContainerType,odinType,odinBuiltinType,odinPointerOperator,odinPolymorphicTypeOperator nextgroup=odinTypeArrow skipwhite
syn match odinType contained "[a-zA-Z_]\w*"
syn match odinContainerTypeName contained "\^\=\(\[\]\)\=\(\.\{2,3}\)\=\^\=\$\=\([a-zA-Z_]\+\.\)\=[a-zA-Z_]\w*\((\|{\)\@=" nextgroup=odinContainerTypeParens
syn match odinContainerType contained "[a-zA-Z_]\w*\((.\{-})\|{.\{-}}\)" contains=odinContainerTypeParens,odinContainerTypeName
syn region odinContainerTypeParens contained start="\((\|{\)" skip="\((.\{-})\|{.\{-}}\)" end="\()\|}\)" contains=odinParameterDec,odinTypeAssignment skipwhite
syn region odinTypeTuple contained start="(" skip="(.\{-})" end=")" contains=odinTypeAssignment

" Functions
syn match odinFunction "[a-z_][a-zA-Z_]*(\@="
syn match odinFunctionDeclaration "\(^\s*\)\@<=[a-z_]\w*\(\s*::\s*proc\)\@=" nextgroup=odinFuncTypeDec skipwhite
syn match odinFuncTypeDec "::" nextgroup=odinProcType,odinTypeAssignment skipwhite
syn keyword odinProcType proc nextgroup=odinProcTypeParameters
syn region odinProcTypeParameters contained start="(" skip="(.\{-})" end=")" contains=odinParameterDec,odinHashStatement nextgroup=odinTypeArrow skipwhite
syn match odinParameterDec contained "\((\|,\)\s*\([a-zA-Z_]\+,\s*\)*[a-zA-Z_]\+\s*:" nextgroup=odinTypeAssignment skipwhite
syn match odinTypeArrow contained "->" nextgroup=odinTypeAssignment,odinTypeTuple skipwhite

syn match odinTypeCast "\u\w*(\@="
syn match odinCastFunction "cast(\@=" nextgroup=odinCastFunctionParens
syn region odinCastFunctionParens contained start="(" skip="(.\{-})" end=")" contains=odinTypeAssignment

syn match odinVariableDec "\([a-z]\w*,\s*\)*[a-z]\w*\s*::\@!" nextgroup=odinTypeAssignment skipwhite

" Operators
syn match odinOperator "\(+=\|-=\|\/\|\*\|%\|\~\|+\|-\|&\|>>\|<<\|>=\|<=\|==\|!=\|!\|>\|<\)"
syn match odinPointerOperator "\^"
syn match odinPolymorphicTypeOperator contained "\$"

" Numbers
syn match odinInteger "\W\@<=[0-9]\+"
syn match odinDecimal "\W\@<=[0-9]\+\.[0-9]\+"

" Bools
syn keyword odinBoolean true false
syn keyword odinNil nil

" Strings
syn region odinString  start='"' skip='\\"' end='"' contains=odinPrintfSpecifier
syn region odinCharacter  start="'" skip="\\'" end="'"
syn match odinPrintfSpecifier contained "%\( \|-\|+\|0\|#\)\=\([0-9]\|\*\)\=\(\.[0-9]\|\.\*\)\=\(hh\|h\|l\|ll\|j\|z\|t\|L\)\=\(t\|v\|c\|r\|b\|o\|d\|z\|x\|X\|U\|f\|F\|s\|p\|T\)"

" Comments
syn region odinCommentBlock start="/\*" end="\*/" contains=odinTODO
syn match odinComment "//.*$" contains=odinTODO
syn match odinTODO contained "\(\(^\|\/\/\)[[:blank:]\*\/]*\)\@<=\u\S*:"

syn match odinHashStatement "#[a-zA-z_][a-zA-z_0-9]*"

" Highlighting
let b:current_syntax = "odin"
hi def link odinKeyword                 Statement
hi def link odinConditional             Conditional
hi def link odinLabel                   Label

hi def link odinString                  String
hi def link odinPrintfSpecifier         Constant
hi def link odinCharacter               Character

hi def link odinProcType                odinType
hi def link odinBuiltinType             odinType
hi def link odinContainerTypeName       odinType
hi def link odinType                    Type

hi def link odinCommentBlock            odinComment
hi def link odinComment                 Comment

hi def link odinInteger                 Number
hi def link odinDecimal                 Number

hi def link odinCastFunction            odinFunction
hi def link odinFunctionDeclaration     odinFunction
hi def link odinFunction                Function

hi def link odinBoolean                 Constant
hi def link odinNil                     Constant

hi def link odinPointerOperator         odinOperator
hi def link odinPolymorphicTypeOperator odinOperator
hi def link odinOperator                Structure

hi def link odinTypeCast                Type

hi def link odinTODO                    Todo

hi def link odinHashStatement           Statement
