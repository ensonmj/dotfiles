#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CLANGD_CONF=${SCRIPT_DIR}/../.clangd
if [ ! -f $CLANGD_CONF ]; then
    cat << EOF > $CLANGD_CONF
CompileFlags:
  Add: 
    - -ferror-limit=0
    - "--include-directory=/workspaces/gluten/ep/build-velox/build/velox_ep/velox/external/xxhash"
EOF
fi

CLANG_TIDY_CONF=${SCRIPT_DIR}/../.clang-tidy
if [ ! -f $CLANG_TIDY_CONF ]; then
    cat << EOF > $CLANG_TIDY_CONF
---
# 配置clang-tidy配置检测项，带'-'前缀的为disable对应的检测，否则为开启。这里主要是关闭一些用处不大，或者存在bug、假阳性的检查项
# clang-tidy --list-checks -checks='*' | grep "modernize"
# https://github.com/cpp-best-practices/gui_starter_template/blob/main/.clang-tidy
Checks: >
  *,
  -abseil-*,
  -altera-*,
  -android-*,
  -fuchsia-*,
  -google-*,
  -llvm*,
  -modernize-use-trailing-return-type,
  -zircon-*,
  -readability-identity-length,
  -readability-static-accessed-through-instance,
  -readability-avoid-const-params-in-decls,
  -cppcoreguidelines-non-private-member-variables-in-classes,
  -misc-non-private-member-variables-in-classes,

# best practice from CLION
# Checks: >
#   -*,
#   bugprone-assert-side-effect,
#   bugprone-bad-signal-to-kill-thread,
#   bugprone-bool-pointer-implicit-conversion,
#   bugprone-branch-clone,
#   bugprone-copy-constructor-init,
#   bugprone-dangling-handle,
#   bugprone-dynamic-static-initializers,
#   bugprone-exception-escape,
#   bugprone-fold-init-type,
#   bugprone-forward-declaration-namespace,
#   bugprone-forwarding-reference-overload,
#   bugprone-implicit-widening-of-multiplication-result,
#   bugprone-inaccurate-erase,
#   bugprone-incorrect-roundings,
#   bugprone-integer-division,
#   bugprone-lambda-function-name,
#   bugprone-macro-repeated-side-effects,
#   bugprone-misplaced-operator-in-strlen-in-alloc,
#   bugprone-misplaced-pointer-arithmetic-in-alloc,
#   bugprone-misplaced-widening-cast,
#   bugprone-move-forwarding-reference,
#   bugprone-multiple-statement-macro,
#   bugprone-no-escape,
#   bugprone-not-null-terminated-result,
#   bugprone-parent-virtual-call,
#   bugprone-posix-return,
#   bugprone-signal-handler,
#   bugprone-signed-char-misuse,
#   bugprone-sizeof-container,
#   bugprone-sizeof-expression,
#   bugprone-spuriously-wake-up-functions,
#   bugprone-string-constructor,
#   bugprone-string-integer-assignment,
#   bugprone-string-literal-with-embedded-nul,
#   bugprone-stringview-nullptr,
#   bugprone-suspicious-enum-usage,
#   bugprone-suspicious-include,
#   bugprone-suspicious-memory-comparison,
#   bugprone-suspicious-memset-usage,
#   bugprone-suspicious-missing-comma,
#   bugprone-suspicious-semicolon,
#   bugprone-suspicious-string-compare,
#   bugprone-swapped-arguments,
#   bugprone-terminating-continue,
#   bugprone-throw-keyword-missing,
#   bugprone-too-small-loop-variable,
#   bugprone-undefined-memory-manipulation,
#   bugprone-undelegated-constructor,
#   bugprone-unhandled-exception-at-new,
#   bugprone-unhandled-self-assignment,
#   bugprone-unused-raii,
#   bugprone-unused-return-value,
#   bugprone-use-after-move,
#   bugprone-virtual-near-miss,
#   cert-dcl21-cpp,
#   cert-dcl50-cpp,
#   cert-dcl58-cpp,
#   cert-err33-c,
#   cert-err34-c,
#   cert-err52-cpp,
#   cert-err58-cpp,
#   cert-err60-cpp,
#   cert-flp30-c,
#   cert-mem57-cpp,
#   cert-msc50-cpp,
#   cert-str34-c,
#   cert-oop57-cpp,
#   cert-oop58-cpp,
#   concurrency-*,
#   cppcoreguidelines-init-variables,
#   cppcoreguidelines-macro-usage,
#   cppcoreguidelines-narrowing-conversions,
#   cppcoreguidelines-no-malloc,
#   cppcoreguidelines-prefer-member-initializer,
#   cppcoreguidelines-pro-bounds-pointer-arithmetic,
#   cppcoreguidelines-pro-type-member-init,
#   cppcoreguidelines-pro-type-static-cast-downcast,
#   cppcoreguidelines-slicing,
#   cppcoreguidelines-special-member-functions,
#   cppcoreguidelines-virtual-class-destructor,
#   fuchsia-multiple-inheritance,
#   google-build-explicit-make-pair,
#   google-default-arguments,
#   google-explicit-constructor,
#   google-readability-avoid-underscore-in-googletest-name,
#   google-runtime-operator,
#   google-upgrade-googletest-case、,
#   hicpp-exception-baseclass,
#   hicpp-multiway-paths-covered,
#   hicpp-no-assembler,
#   llvm-*,
#   misc-definitions-in-headers,
#   misc-misleading-bidirectional,
#   misc-misplaced-const,
#   misc-new-delete-overloads,
#   misc-non-copyable-objects,
#   misc-static-assert,
#   misc-throw-by-value-catch-by-reference,
#   misc-unconventional-assign-operator,
#   misc-uniqueptr-reset-release,
#   modernize-avoid-bind,
#   modernize-concat-nested-namespaces,
#   modernize-deprecated-headers,
#   modernize-deprecated-ios-base-aliases,
#   modernize-loop-convert,
#   modernize-make-shared,
#   modernize-make-unique,
#   modernize-pass-by-value,
#   modernize-raw-string-literal,
#   modernize-redundant-void-arg,
#   modernize-replace-auto-ptr,
#   modernize-replace-disallow-copy-and-assign-macro,
#   modernize-replace-random-shuffle,
#   modernize-return-braced-init-list,
#   modernize-shrink-to-fit,
#   modernize-unary-static-assert,
#   modernize-use-auto,
#   modernize-use-bool-literals,
#   modernize-use-default-member-init,
#   modernize-use-emplace,
#   modernize-use-equals-default,
#   modernize-use-equals-delete,
#   modernize-use-nodiscard,
#   modernize-use-noexcept,
#   modernize-use-nullptr,
#   modernize-use-override,
#   modernize-use-transparent-functors,
#   modernize-use-uncaught-exceptions,
#   mpi-*,
#   openmp-use-default-none,
#   performance-faster-string-find,
#   performance-for-range-copy,
#   performance-implicit-conversion-in-loop,
#   performance-inefficient-algorithm,
#   performance-inefficient-string-concatenation,
#   performance-inefficient-vector-operation,
#   performance-move-const-arg,
#   performance-move-constructor-init,
#   performance-no-automatic-move,
#   performance-no-int-to-ptr,
#   performance-noexcept-move-constructor,
#   performance-trivially-destructible,
#   performance-type-promotion-in-math-fn,
#   performance-unnecessary-copy-initialization,
#   performance-unnecessary-value-param,
#   portability-simd-intrinsics,
#   readability-avoid-const-params-in-decls,
#   readability-braces-around-statements,
#   readability-const-return-type,
#   readability-container-data-pointer,
#   readability-container-size-empty,
#   readability-convert-member-functions-to-static,
#   readability-delete-null-pointer,
#   readability-deleted-default,
#   readability-inconsistent-declaration-parameter-name,
#   readability-make-member-function-const,
#   readability-misleading-indentation,
#   readability-misplaced-array-index,
#   readability-non-const-parameter,
#   readability-qualified-auto,
#   readability-redundant-access-specifiers,
#   readability-redundant-control-flow,
#   readability-redundant-declaration,
#   readability-redundant-function-ptr-dereference,
#   readability-redundant-member-init,
#   readability-redundant-preprocessor,
#   readability-redundant-smartptr-get,
#   readability-redundant-string-cstr,
#   readability-redundant-string-init,
#   readability-simplify-boolean-expr,
#   readability-simplify-subscript-expr,
#   readability-static-accessed-through-instance,
#   readability-static-definition-in-anonymous-namespace,
#   readability-string-compare,
#   readability-uniqueptr-delete-release,
#   readability-use-anyofallof,

# 将警告转为错误
WarningsAsErrors: '*,-misc-non-private-member-variables-in-classes'
FormatStyle: file
# 过滤检查哪些头文件，clang-tidy会把源码依赖的头文件列出来都检查一遍，所以要屏蔽大量第三方库中的头文件
# 参考 https://stackoverflow.com/questions/71797349/is-it-possible-to-ignore-a-header-with-clang-tidy
# 该正则表达式引擎为llvm::Regex，支持的表达式较少，(?!xx)负向查找等都不支持
HeaderFilterRegex: '(xxx/include)*\.h$'
# 具体一些检查项的配置参数，可以参考的：
# https://github.com/envoyproxy/envoy/blob/main/.clang-tidy
# https://github.com/ClickHouse/ClickHouse/blob/d1d2f2c1a4979d17b7d58f591f56346bc79278f8/.clang-tidy
# CheckOptions:
#   - { key: readability-identifier-naming.NamespaceCase,          value: lower_case }
#   - { key: readability-identifier-naming.FunctionCase,           value: camelBack  }
#   - { key: readability-identifier-naming.VariableCase,           value: camelBack  }
#   - { key: readability-identifier-naming.ClassMemberCase,        value: camelBack  }
#   - { key: readability-identifier-naming.ClassMemberSuffix,      value: _          }
#   - { key: readability-identifier-naming.PrivateMemberCase,      value: camelBack  }
#   - { key: readability-identifier-naming.PrivateMemberSuffix,    value: _          }
#   - { key: readability-identifier-naming.ProtectedMemberCase,    value: camelBack  }
#   - { key: readability-identifier-naming.ProtectedMemberSuffix,  value: _          }
#   - { key: readability-identifier-naming.ParameterCase,          value: camelBack  }
#   - { key: readability-identifier-naming.ParameterPackCase,      value: camelBack  }
#   - { key: readability-identifier-naming.PointerParameterCase,   value: camelBack  }
#   - { key: readability-identifier-naming.ClassCase,              value: CamelCase  }
#   - { key: readability-identifier-naming.StructCase,             value: CamelCase  }
#   - { key: readability-identifier-naming.TemplateParameterCase,  value: CamelCase  }
#   - { key: readability-identifier-naming.EnumConstantCase,         value: CamelCase }
#   - { key: readability-identifier-naming.EnumConstantPrefix,       value: k         }
#   - { key: readability-identifier-naming.ConstexprVariableCase,    value: CamelCase }
#   - { key: readability-identifier-naming.ConstexprVariablePrefix,  value: k         }
#   - { key: readability-identifier-naming.GlobalConstantCase,       value: CamelCase }
#   - { key: readability-identifier-naming.GlobalConstantPrefix,     value: k         }
#   - { key: readability-identifier-naming.MemberConstantCase,       value: CamelCase }
#   - { key: readability-identifier-naming.MemberConstantPrefix,     value: k         }
#   - { key: readability-identifier-naming.StaticConstantCase,       value: CamelCase }
#   - { key: readability-identifier-naming.StaticConstantPrefix,     value: k         }
#   - { key: readability-identifier-naming.MacroDefinitionCase,      value: UPPER_CASE }
EOF
fi
