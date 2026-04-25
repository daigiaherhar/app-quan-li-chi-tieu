#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

function fail(message) {
  process.stderr.write(`Failure: ${message}\n`);
  process.exit(1);
}

function ensureDir(dirPath) {
  fs.mkdirSync(dirPath, { recursive: true });
}

function writeFileIfMissing(filePath, content) {
  if (fs.existsSync(filePath)) {
    return false;
  }
  fs.writeFileSync(filePath, content, "utf8");
  return true;
}

function toPascalCase(value) {
  return value
    .split("_")
    .filter(Boolean)
    .map((segment) => segment.charAt(0).toUpperCase() + segment.slice(1))
    .join("");
}

function buildEntity(featureClassName) {
  return `class ${featureClassName}Entity {
  const ${featureClassName}Entity({
    required this.id,
  });

  final String id;

  ${featureClassName}Entity copyWith({
    String? id,
  }) {
    return ${featureClassName}Entity(
      id: id ?? this.id,
    );
  }
}
`;
}

function buildRepository(featureName, featureClassName) {
  return `import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/${featureName}/domain/entities/${featureName}_entity.dart';

abstract class ${featureClassName}Repository {
  Future<Result<${featureClassName}Entity>> get${featureClassName}();
}
`;
}

function buildUseCase(featureName, featureClassName) {
  return `import 'package:quan_ly_chi_tieu/core/base/base_usecases.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/${featureName}/domain/entities/${featureName}_entity.dart';
import 'package:quan_ly_chi_tieu/features/${featureName}/domain/repositories/${featureName}_repository.dart';

class Get${featureClassName}UseCase extends BaseUseCaseNoParams<${featureClassName}Entity> {
  Get${featureClassName}UseCase(
    this._repository,
  );

  final ${featureClassName}Repository _repository;

  @override
  Future<Result<${featureClassName}Entity>> call() async {
    return _repository.get${featureClassName}();
  }
}
`;
}

function buildPage(featureName, featureClassName) {
  return `import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/shared/widgets/appbar/base_app_bar.dart';

part '../widgets/header/${featureName}_header.dart';
part '../widgets/body/${featureName}_body.dart';

class ${featureClassName}Page extends ConsumerWidget {
  const ${featureClassName}Page({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const _${featureClassName}Header(
        title: '${featureClassName}',
      ),
      body: const _${featureClassName}Body(),
    );
  }
}
`;
}

function buildHeader(featureName, featureClassName) {
  return `part of '../../pages/${featureName}_page.dart';

class _${featureClassName}Header extends StatelessWidget implements PreferredSizeWidget {
  const _${featureClassName}Header({
    required this.title,
  });

  final String title;

  @override
  Widget build(
    BuildContext context,
  ) {
    return BaseAppBar(
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight,
      );
}
`;
}

function buildBody(featureName, featureClassName) {
  return `part of '../../pages/${featureName}_page.dart';

class _${featureClassName}Body extends StatelessWidget {
  const _${featureClassName}Body();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: context.padding.all16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${featureClassName} feature',
            style: context.textStyles.h2,
          ),
          context.gap.h8,
          Text(
            'Replace this placeholder UI with real content.',
            style: context.textStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}
`;
}

function main() {
  const featureName = process.argv[2];
  if (!featureName) {
    fail("Missing feature name. Usage: node scaffold_feature.cjs <feature_name>");
  }
  if (!/^[a-z0-9_]+$/.test(featureName)) {
    fail("Feature name must be snake_case and contain only a-z, 0-9, _");
  }
  const repoRoot = process.cwd();
  const featureRoot = path.join(repoRoot, "lib", "features", featureName);
  const featureClassName = toPascalCase(featureName);
  const directories = [
    path.join(featureRoot, "data", "datasources"),
    path.join(featureRoot, "data", "models"),
    path.join(featureRoot, "data", "repositories"),
    path.join(featureRoot, "domain", "entities"),
    path.join(featureRoot, "domain", "repositories"),
    path.join(featureRoot, "domain", "usecases"),
    path.join(featureRoot, "presentation", "pages"),
    path.join(featureRoot, "presentation", "widgets", "header"),
    path.join(featureRoot, "presentation", "widgets", "body"),
    path.join(featureRoot, "presentation", "widgets", "footer"),
    path.join(featureRoot, "presentation", "providers"),
  ];
  directories.forEach(ensureDir);
  const files = [
    [
      path.join(featureRoot, "domain", "entities", `${featureName}_entity.dart`),
      buildEntity(featureClassName),
    ],
    [
      path.join(featureRoot, "domain", "repositories", `${featureName}_repository.dart`),
      buildRepository(featureName, featureClassName),
    ],
    [
      path.join(featureRoot, "domain", "usecases", `get_${featureName}_usecase.dart`),
      buildUseCase(featureName, featureClassName),
    ],
    [
      path.join(featureRoot, "presentation", "pages", `${featureName}_page.dart`),
      buildPage(featureName, featureClassName),
    ],
    [
      path.join(featureRoot, "presentation", "widgets", "header", `${featureName}_header.dart`),
      buildHeader(featureName, featureClassName),
    ],
    [
      path.join(featureRoot, "presentation", "widgets", "body", `${featureName}_body.dart`),
      buildBody(featureName, featureClassName),
    ],
  ];
  const created = [];
  const skipped = [];
  for (const [filePath, content] of files) {
    const didCreate = writeFileIfMissing(filePath, content);
    if (didCreate) {
      created.push(path.relative(repoRoot, filePath));
    } else {
      skipped.push(path.relative(repoRoot, filePath));
    }
  }
  const lines = [
    `Success: scaffolded feature '${featureName}'.`,
    created.length > 0 ? `Created: ${created.join(", ")}` : "Created: none",
    skipped.length > 0 ? `Skipped existing: ${skipped.join(", ")}` : "Skipped existing: none",
  ];
  process.stdout.write(`${lines.join("\n")}\n`);
}

main();
