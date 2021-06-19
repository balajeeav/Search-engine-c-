#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QtCore>
#include "scriptrunner.h"

typedef QPair<QString, QString> SearchTask;

class Controller : public QObject {
  Q_OBJECT
public:
  explicit Controller(QObject *parent = 0);
  virtual ~Controller();

  static void setConsts();

  static QList<QString> engines();

  static QString renderTemplate(const QString& templateName, const QVariantMap& keys);
  static QString getGraph(const QList<int>& real, const QList<double>& approx);
  static QString getConstPage(const QString& name);

  bool isComplite() const;
  bool saveResults(const QString& filePath);

signals:
  void complite(const QString& content, const QString title);
  void setTimeOut(const int millisec);
  void setInfo(const QString& info);

  void startThreads();

public slots:
  void search(const QString& names, const QString& type);
  void constPage(const QString& templateName);
  void addResult(const SearchTask& task, const QVariantMap& keys);

private:
  static void loadTemplate(const QString& tepmplatePath, const QString& name);
  static void loadTemplates();

  static QMap<QString, QStringList> handlers;
  static QMap<QString, QString> engineRepr;
  static QMap<QString, QString> commands;
  static QMap<QString, QString> templates;
  static QString workingPath;

  static QRegExp replaceReg;
  static QRegExp applyReg;

  void searchBy(const QStringList& names, const QString& engine);
  void sheduleTask(const SearchTask& task);
  void processResults();

  QVariantList mapToList(const QString& key, const QVariantMap& map);
  void cleanUp();

  QMap<SearchTask, QThread*> workers;
  QString searchHandler;
  QVariantMap incompliteKeys;
  int timeout;
  bool locked;
  int tasksMax;
  int tasks;

};

#endif // CONTROLLER_H
