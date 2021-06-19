#ifndef SCRIPTRUNNER_H
#define SCRIPTRUNNER_H

#include <QObject>
#include <QtCore>

typedef QPair<QString, QString> SearchTask;

class ScriptRunner : public QObject
{
  Q_OBJECT
public:
  explicit ScriptRunner(const SearchTask& task, const QString& workDir,
                        const QString script, const int timeout, QObject *parent = 0);
  
signals:
  void complite(const SearchTask& task, QVariantMap result);
  
public slots:
  void search();
  void procFinished(int retcode);
  void timeOut();

private:
  void normalFinish();
  void errorFinish();
  QVariantMap decode(const QStringList& content);

private:
  QString workingPath;
  QString outPath;
  QString script;
  SearchTask task;
  QProcess * process;
  int timeout;

  static int scriptId;
  static QRegExp simplifyReg;
};

#endif // SCRIPTRUNNER_H
