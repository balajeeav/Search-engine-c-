#ifndef PAGEVIEW_H
#define PAGEVIEW_H

#include <QWidget>
#include "controller.h"
#define BASIC_TIMEOUT (1000 * 60)

namespace Ui {
class PageView;
}

class PageView : public QWidget
{
  Q_OBJECT
  
public:
  explicit PageView(QWidget *parent = 0);
  ~PageView();

signals:
  void searchRequest(const QString& names, const QString& engine);
  void constPageRequest(const QString& templateName);
  void titleChange(const QString& title, PageView* self);
  void changed();

public slots:
  void setContent(const QString& content, const QString& title);
  void setInfo(const QString& info);

  void search(const QString& names, const QString& engine);
  void setConstPage(const QString& templateName);

  void saveResults();

protected slots:
  void setTimeOut(int millisec);
  void timerEvent(QTimerEvent *);

private:
  Ui::PageView *ui;
  Controller * controller;
  int timeout;
  int timerId;
};

#endif // PAGEVIEW_H
