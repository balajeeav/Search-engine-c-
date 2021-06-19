#include "scriptrunner.h"

int ScriptRunner::scriptId = 0;
QRegExp ScriptRunner::simplifyReg = QRegExp("\\s+");

ScriptRunner::ScriptRunner(const SearchTask &task, const QString &workDir,
                           const QString script, const int timeout,
                           QObject *parent) :
  QObject(parent), workingPath(workDir), script(script), task(task), timeout(timeout) {
  this->outPath = this->workingPath + "output_" +
                  task.first.trimmed().replace(ScriptRunner::simplifyReg, "_") + "_" + task.second + ".txt";
}

void ScriptRunner::search() {
  QProcess * process = new QProcess();
  this->process = process;
  process->setWorkingDirectory(this->workingPath);

  QTimer * timer = new QTimer(this);
  timer->setInterval(timeout);
  timer->setSingleShot(true);
  timer->start();

  connect(process, SIGNAL(finished(int)), this, SLOT(procFinished(int)), Qt::QueuedConnection);
  connect(process, SIGNAL(finished(int)), process, SLOT(deleteLater()), Qt::QueuedConnection);

  connect(timer, SIGNAL(timeout()), this, SLOT(timeOut()));

  connect(this, SIGNAL(destroyed()), process, SLOT(kill()), Qt::QueuedConnection);

  process->start("sh", QStringList() << this->workingPath + "start.sh"
                 << this->task.first << this->outPath
                 << this->script << this->outPath + ".log");
}

void ScriptRunner::timeOut() {
  disconnect(process, SIGNAL(finished(int)), this, SLOT(procFinished(int)));
  disconnect(process, SIGNAL(finished(int)), process, SLOT(deleteLater()));
  this->process->terminate();

  QVariantMap answer;
  answer.insert("status", QVariant("fail"));
  answer.insert("reason", QVariant("timeout"));
  emit complite(this->task, answer);
}

void ScriptRunner::procFinished(int retcode) {
  if (retcode == 0) {
    this->normalFinish();
  } else {
    this->errorFinish();
  }
}

void ScriptRunner::normalFinish() {
  QFile out(this->outPath);
  if (!out.open(QIODevice::ReadOnly)) {
    this->errorFinish();
    return;
  }
  const QStringList content = QString(out.readAll()).split("\n");
  out.close();
  const QVariantMap answer = this->decode(content);
  emit this->complite(this->task, answer);
}

void ScriptRunner::errorFinish() {
  QFile log(this->outPath + ".log");
  QVariantMap answer;
  answer.insert("status", QVariant("fail"));
  if (!log.open(QIODevice::ReadOnly)) {
    answer.insert("reason", QVariant("No log file!"));
  } else {
    const QString reason =  QString(log.readAll());
    answer.insert("reason", QVariant(reason));
  }
  emit this->complite(this->task, answer);
}

QVariantMap ScriptRunner::decode(const QStringList &content) {
  QVariantMap answer;
  answer.insert("content", content.join("\n"));
  if (content.length() < 5) {
    answer.insert("status", QVariant("fail"));
    answer.insert("reason", QVariant("Bad search result file."));
    return answer;
  }

  try {
    bool isOk;
    int articles = content.at(0).toInt(&isOk);
    int processedArticles = content.at(1).toInt(&isOk);
    bool isApprox = (content.at(2).toInt(&isOk) == 1);
    int hIndex = content.at(3).toInt(&isOk);
    int years = content.at(4).toInt(&isOk);

    answer.insert("articles", QVariant(articles));
    answer.insert("processed", QVariant(processedArticles));
    answer.insert("h_index", QVariant(hIndex));
    answer.insert("years", QVariant(years));

    QVariantList citations;
    citations.reserve(processedArticles);
    for (int i = 0; i < processedArticles && 5 + i < content.length(); ++i) {
      citations.push_back(QVariant(content.at(5 + i).toInt()));
    }
    answer.insert("citations", QVariant(citations));
    if (isApprox) {
      QVariantList approx;
      for (int i = 5 + processedArticles; i < content.length() && i - processedArticles - 5 < processedArticles; ++i) {
        approx.push_back(QVariant(content.at(i).toDouble()));
      }
      answer.insert("approx", QVariant(approx));
    }
    answer.insert("status", QVariant("ok"));
  } catch (...) {
    answer.insert("status", QVariant("fail"));
    answer.insert("reason", QVariant("Bad data from script out."));
  }
  return answer;
}
