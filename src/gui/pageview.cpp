#include "pageview.h"
#include "ui_pageview.h"

#include <QtGui>

PageView::PageView(QWidget *parent) :
  QWidget(parent),
  ui(new Ui::PageView) {
  ui->setupUi(this);
  this->timerId = -1;
  this->controller = new Controller(this);

  connect(this->controller, SIGNAL(complite(QString,QString)), this, SLOT(setContent(QString,QString)), Qt::QueuedConnection);
  connect(this->controller, SIGNAL(setTimeOut(int)), this, SLOT(setTimeOut(int)),  Qt::QueuedConnection);
  connect(this->controller, SIGNAL(setInfo(QString)), this, SLOT(setInfo(QString)),  Qt::QueuedConnection);

  connect(this, SIGNAL(constPageRequest(QString)), this->controller, SLOT(constPage(QString)),  Qt::QueuedConnection);
  connect(this, SIGNAL(searchRequest(QString,QString)), this->controller, SLOT(search(QString,QString)),  Qt::QueuedConnection);

  connect(this->ui->saveBtn, SIGNAL(pressed()), this, SLOT(saveResults()));
}

void PageView::setTimeOut(int millisec) {
  this->timeout = millisec;
  this->timerId = startTimer(1000);
  this->ui->progressBar->setMaximum(this->timeout / 1000);
}

void PageView::timerEvent(QTimerEvent * timerEvent) {
  if (timerEvent->timerId() == this->timerId) {
    this->ui->progressBar->setValue(this->ui->progressBar->value() + 1);
  } else {
    QObject::timerEvent(timerEvent);
  }
}

PageView::~PageView() {
  delete ui;
  this->controller->deleteLater();

  if (this->timerId != -1) {
    killTimer(this->timerId);
  }
}

void PageView::saveResults() {
  if (!this->controller->isComplite()) {
    QMessageBox msg;
    msg.setText("Searching is incomplite now.");
    msg.setInformativeText("Do you want to save partial results?");
    msg.setStandardButtons(QMessageBox::Ok | QMessageBox::Cancel);
    msg.setDefaultButton(QMessageBox::Ok);
    int answer = msg.exec();
    if (answer == QMessageBox::Cancel) {
      return;
    }
  }
  QString path = QFileDialog::getSaveFileName(this, "Save search results");
  bool succ = this->controller->saveResults(path);
  if (!succ) {
    QErrorMessage error;
    error.showMessage("Can not save search results", "Bad file!");
  }
}

void PageView::setConstPage(const QString &templateName) {
  emit this->constPageRequest(templateName);
}

void PageView::search(const QString &names, const QString &engine) {
  controller->search(names, engine);
}

void PageView::setContent(const QString &content, const QString &title) {
  if (this->timerId != -1) {
    this->killTimer(this->timerId);
  }
  this->ui->browser->setText(content);
  emit this->titleChange(title, this);
  emit changed();
}

void PageView::setInfo(const QString &info) {
  this->ui->info->setText(info);
}
