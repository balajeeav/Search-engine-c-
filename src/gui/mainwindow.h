
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtGui/QMainWindow>
#include "pageview.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow {
  Q_OBJECT

public:
  explicit MainWindow(QWidget *parent = 0);
  ~MainWindow();

public slots:
  void searchRequest();

  void getInfo();
  void getAbout();

  void closeTab(int index);
  void titleChange(const QString& title, PageView* caller);

  void loadFile();

private:
  Ui::MainWindow* ui;
  QVector<PageView* > pages;

  PageView* getNewPage();
};

#endif // MAINWINDOW_H
