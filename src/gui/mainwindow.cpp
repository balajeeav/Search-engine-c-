#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QtGui>

MainWindow::MainWindow(QWidget *parent) :
  QMainWindow(parent),
  ui(new Ui::MainWindow) {

  Controller::setConsts();

  ui->setupUi(this);

  QList<QString> engines = Controller::engines();
  this->ui->engineBox->insertItems(1, engines);

  connect(this->ui->okBtn, SIGNAL(clicked()), this, SLOT(searchRequest()));
  connect(this->ui->nameEdit, SIGNAL(returnPressed()), this, SLOT(searchRequest()));

  connect(this->ui->tabs, SIGNAL(tabCloseRequested(int)), this, SLOT(closeTab(int)));

  connect(this->ui->actionHelp, SIGNAL(triggered()), this, SLOT(getInfo()));
  connect(this->ui->actionAbout, SIGNAL(triggered()), this, SLOT(getAbout()));

  connect(this->ui->fileOpen, SIGNAL(clicked()), this, SLOT(loadFile()));

  this->getInfo();
}

MainWindow::~MainWindow() {
  delete ui;
}

void MainWindow::searchRequest() {
  QString engine = this->ui->engineBox->currentText();
  QString name = this->ui->nameEdit->text();
  PageView* page = getNewPage();
  page->search(name, engine);
}

void MainWindow::getInfo() {
  PageView* page = getNewPage();
  page->setConstPage("info");
}

void MainWindow::getAbout() {
  PageView* page = getNewPage();
  page->setConstPage("about");
}

void MainWindow::titleChange(const QString &title, PageView *caller) {
  int i = this->pages.indexOf(caller);
  if (i >= 0 && i < this->pages.size()) {
    this->ui->tabs->setTabText(i, title);
  } else {
    qDebug() << "Wrong caller of title change with title " << title << "!";
  }
}

void MainWindow::closeTab(int index) {
  delete this->pages.at(index);
  this->pages.remove(index);
}

PageView* MainWindow::getNewPage() {
  PageView* page = new PageView(this->ui->tabs);
  this->ui->tabs->insertTab(this->ui->tabs->count(), page, "Page");
  this->pages.push_back(page);
  this->ui->tabs->setCurrentIndex(this->ui->tabs->count() - 1);
  connect(page, SIGNAL(titleChange(QString,PageView*)), this, SLOT(titleChange(QString,PageView*)));
  return page;
}

void MainWindow::loadFile() {
  QString path = QFileDialog::getOpenFileName(this, "Select input file");
  QFile file(path);
  if (!file.open(QIODevice::ReadOnly)) {
    QErrorMessage msg;
    msg.showMessage("Can not read input file!", "Bad file.");
    return;
  }
  QStringList inputs = QString(file.readAll()).split("\n");
  QStringList::Iterator input = inputs.begin();
  while(input != inputs.end()) {
    *input = input->trimmed();
    if (input->length() < 3) {
      input = inputs.erase(input);
    } else {
      ++input;
    }
  }
  qDebug() << inputs;
  this->ui->nameEdit->setText(inputs.join(", "));
}
