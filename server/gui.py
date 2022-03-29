import sys
from PyQt5 import QtWidgets, QtGui, QtCore, uic
from PyQt5.QtGui import QIcon, QPixmap
from pll import RedPitaya
from mainWindow import Ui_MainWindow
import pickle


HOSTNAME = '192.168.1.14'
USERNAME = 'root'
PASSWORD = 'root'
NPLL = '2'

glob_parameter_keys = ['output_1', 'output_2', 'ext_pins_p', 'ext_pins_n']




class GUI(QtWidgets.QMainWindow):
    comboBox_output = {}
    checkboxes = {}

    def __init__(self, **kwargs):
        QtWidgets.QDialog.__init__(self)
        hostuserpass, ok = QtWidgets.QInputDialog.getText(self, "Enter Login Details","HOSTNAME,USERNAME,PASSWORD,NPLL:", QtWidgets.QLineEdit.Normal, HOSTNAME + ',' + USERNAME + ',' + PASSWORD)
        [hostname, username, password] = hostuserpass.split(',')
        npll = 2
        if not(ok):
            raise Exception('Aborted')
        
        self.rp = RedPitaya(hostname, username, password, n_pll=int(npll))

        # Set up the user interface from Designer.
        self.ui = uic.loadUi('mainWindow.ui')
        self.ui.show()
        self.ui.actionQuit.triggered.connect(self.close_application)
        self.ui.actionQuit.setShortcut('Ctrl+Q')
        self.ui.actionLoad_File.triggered.connect(self.load_parameters)
        self.ui.actionLoad_File.setShortcut('Ctrl+L')
        self.ui.actionSave_File.triggered.connect(self.save_file)
        self.ui.actionSave_File.setShortcut('Ctrl+S')
        self.ui.actionAbout.triggered.connect(self.about_pop_up)
        
        
        # Initiation: update values in Plls Table, comboboxes
        self.ui.a_pll1.setText(self.rp.read_parameter_user('a'))
        self.ui.a_pll2.setText(self.rp.read_parameter_user('a', pll=1))
        self.ui.phi_pll1.setText(self.rp.read_parameter_user('phi'))
        self.ui.phi_pll2.setText(self.rp.read_parameter_user('phi', pll=1))
        self.ui.kp_pll1.setText(self.rp.read_parameter_user('kp'))
        self.ui.kp_pll2.setText(self.rp.read_parameter_user('kp', pll=1))
        self.ui.ki_pll1.setText(self.rp.read_parameter_user('ki'))
        self.ui.ki_pll2.setText(self.rp.read_parameter_user('ki', pll=1))
        self.ui.f0_pll1.setText(self.rp.read_parameter_user('f0'))
        self.ui.f0_pll2.setText(self.rp.read_parameter_user('f0', pll=1))
        self.ui.bw_pll1.setText(self.rp.read_parameter_user('bw'))
        self.ui.bw_pll2.setText(self.rp.read_parameter_user('bw', pll=1))
        self.ui.alpha_pll1.setText(self.rp.read_parameter_user('alpha'))
        self.ui.alpha_pll2.setText(self.rp.read_parameter_user('alpha', pll=1))
        self.ui.order_pll1.setText(self.rp.read_parameter_user('order'))
        self.ui.order_pll2.setText(self.rp.read_parameter_user('order', pll=1))
        self.ui.output_1.setCurrentText(self.rp.read_parameter_user('output_1'))
        self.ui.output_2.setCurrentText(self.rp.read_parameter_user('output_2'))
        # PLL 1
        self.ui.alpha_pll1_tab2.setText(self.rp.read_parameter_user('alpha'))
        self.ui.alpha_pll1_tab2.adjustSize()
        self.ui.order_pll1_tab2.setText(self.rp.read_parameter_user('order'))
        self.ui.kp_pll1_tab2.setText(self.rp.read_parameter_user('kp'))
        self.ui.ki_pll1_tab2.setText(self.rp.read_parameter_user('ki'))
        self.ui.bw_pll1_tab2.setText(self.rp.read_parameter_user('bw'))
        self.ui.bw_pll1_tab2.adjustSize()
        self.ui.f0_pll1_tab2.setText(self.rp.read_parameter_user('f0'))
        self.ui.f0_pll1_tab2.adjustSize()
        self.ui.a_pll1_tab2.setText(self.rp.read_parameter_user('a'))
        self.ui.a_pll1_tab2.adjustSize()
        self.ui.phi_pll1_tab2.setText(self.rp.read_parameter_user('phi'))
        self.ui.phi_pll1_tab2.adjustSize()
        # PLL 2
        self.ui.alpha_pll2_tab2.setText(self.rp.read_parameter_user('alpha', pll=1))
        self.ui.alpha_pll2_tab2.adjustSize()
        self.ui.order_pll2_tab2.setText(self.rp.read_parameter_user('order', pll=1))
        self.ui.kp_pll2_tab2.setText(self.rp.read_parameter_user('kp', pll=1))
        self.ui.ki_pll2_tab2.setText(self.rp.read_parameter_user('ki', pll=1))
        self.ui.bw_pll2_tab2.setText(self.rp.read_parameter_user('bw', pll=1))
        self.ui.bw_pll2_tab2.adjustSize()
        self.ui.f0_pll2_tab2.setText(self.rp.read_parameter_user('f0', pll=1))
        self.ui.f0_pll2_tab2.adjustSize()
        self.ui.a_pll2_tab2.setText(self.rp.read_parameter_user('a', pll=1))
        self.ui.phi_pll2_tab2.setText(self.rp.read_parameter_user('phi', pll=1))
        self.ui.phi_pll2_tab2.adjustSize()
        

        self.ui.pushButton.clicked.connect(self.update_table_widget)
        
        self.ui.output_1.activated[str].connect(self.update_output_1)
        self.ui.output_2.activated[str].connect(self.update_output_2)
        
    # Check Boxes
        # TAB 1
        self.ui.second_harm_pll1.setCheckState({'0': QtCore.Qt.Unchecked, '1': QtCore.Qt.Checked}[self.rp.read_parameter_user('2nd_harm', pll=0)])
        self.ui.second_harm_pll1.stateChanged.connect(lambda state, param_ = '2nd_harm', pll_ = 0: self.updateParam(param_, {QtCore.Qt.Unchecked: '0', QtCore.Qt.Checked: '1'}[state], pll_))
        self.ui.pid_en_pll1.setCheckState({'0': QtCore.Qt.Unchecked, '1': QtCore.Qt.Checked}[self.rp.read_parameter_user('pid_en', 0)])
        self.ui.pid_en_pll1.stateChanged.connect(lambda state, param_ = 'pid_en', pll_ = 0: self.updateParam(param_, {QtCore.Qt.Unchecked: '0', QtCore.Qt.Checked: '1'}[state], pll_))
        self.ui.second_harm_pll2.setCheckState({'0': QtCore.Qt.Unchecked, '1': QtCore.Qt.Checked}[self.rp.read_parameter_user('2nd_harm', 1)])
        self.ui.second_harm_pll2.stateChanged.connect(lambda state, param_ = '2nd_harm', pll_ = 1: self.updateParam(param_, {QtCore.Qt.Unchecked: '0', QtCore.Qt.Checked: '1'}[state], pll_))
        self.ui.pid_en_pll2.setCheckState({'0': QtCore.Qt.Unchecked, '1': QtCore.Qt.Checked}[self.rp.read_parameter_user('pid_en', 1)])
        self.ui.pid_en_pll2.stateChanged.connect(lambda state, param_ = 'pid_en', pll_ = 1: self.updateParam(param_, {QtCore.Qt.Unchecked: '0', QtCore.Qt.Checked: '1'}[state], pll_))
        # TAB 2
        self.ui.second_harm_pll1_tab2.setCheckState({'0': QtCore.Qt.Unchecked, '1': QtCore.Qt.Checked}[self.rp.read_parameter_user('2nd_harm', pll=0)])
        self.ui.second_harm_pll1_tab2.stateChanged.connect(lambda state, param_ = '2nd_harm', pll_ = 0: self.updateParam(param_, {QtCore.Qt.Unchecked: '0', QtCore.Qt.Checked: '1'}[state], pll_))
        self.ui.pid_en_pll1_tab2.setCheckState({'0': QtCore.Qt.Unchecked, '1': QtCore.Qt.Checked}[self.rp.read_parameter_user('pid_en', 0)])
        self.ui.pid_en_pll1_tab2.stateChanged.connect(lambda state, param_ = 'pid_en', pll_ = 0: self.updateParam(param_, {QtCore.Qt.Unchecked: '0', QtCore.Qt.Checked: '1'}[state], pll_))
        self.ui.second_harm_pll2_tab2.setCheckState({'0': QtCore.Qt.Unchecked, '1': QtCore.Qt.Checked}[self.rp.read_parameter_user('2nd_harm', 1)])
        self.ui.second_harm_pll2_tab2.stateChanged.connect(lambda state, param_ = '2nd_harm', pll_ = 1: self.updateParam(param_, {QtCore.Qt.Unchecked: '0', QtCore.Qt.Checked: '1'}[state], pll_))
        self.ui.pid_en_pll2_tab2.setCheckState({'0': QtCore.Qt.Unchecked, '1': QtCore.Qt.Checked}[self.rp.read_parameter_user('pid_en', 1)])
        self.ui.pid_en_pll2_tab2.stateChanged.connect(lambda state, param_ = 'pid_en', pll_ = 1: self.updateParam(param_, {QtCore.Qt.Unchecked: '0', QtCore.Qt.Checked: '1'}[state], pll_))

    # Connection between checkboxes in different tabs
            
        self.ui.second_harm_pll1.stateChanged.connect(self.second_harm_pll1)
        self.ui.second_harm_pll1_tab2.stateChanged.connect(self.second_harm_pll1_tab2)
        self.ui.second_harm_pll2.stateChanged.connect(self.second_harm_pll2)
        self.ui.second_harm_pll2_tab2.stateChanged.connect(self.second_harm_pll2_tab2)
        
        self.ui.pid_en_pll1.stateChanged.connect(self.pid_en_pll1)
        self.ui.pid_en_pll1_tab2.stateChanged.connect(self.pid_en_pll1_tab2)
        self.ui.pid_en_pll2.stateChanged.connect(self.pid_en_pll2)
        self.ui.pid_en_pll2_tab2.stateChanged.connect(self.pid_en_pll2_tab2)

    #----- Pll Table Labels----------
        #a
        self.ui.a_pll1.editingFinished.connect(self.update_a)
        self.ui.a_pll2.editingFinished.connect(self.update_a2)
        self.ui.a_pll1_tab2.editingFinished.connect(self.update_a_tab2)
        self.ui.a_pll2_tab2.editingFinished.connect(self.update_a2_tab2)
        #phi
        self.ui.phi_pll1.editingFinished.connect(self.update_phi)
        self.ui.phi_pll2.editingFinished.connect(self.update_phi2)
        self.ui.phi_pll1_tab2.editingFinished.connect(self.update_phi_tab2)
        self.ui.phi_pll2_tab2.editingFinished.connect(self.update_phi2_tab2)
        #kp
        self.ui.kp_pll1.editingFinished.connect(self.update_kp)
        self.ui.kp_pll2.editingFinished.connect(self.update_kp2)
        self.ui.kp_pll1_tab2.editingFinished.connect(self.update_kp_tab2)
        self.ui.kp_pll2_tab2.editingFinished.connect(self.update_kp2_tab2)
        #ki
        self.ui.ki_pll1.editingFinished.connect(self.update_ki)
        self.ui.ki_pll2.editingFinished.connect(self.update_ki2)
        self.ui.ki_pll1_tab2.editingFinished.connect(self.update_ki_tab2)
        self.ui.ki_pll2_tab2.editingFinished.connect(self.update_ki2_tab2)
        #f0
        self.ui.f0_pll1.editingFinished.connect(self.update_f0)
        self.ui.f0_pll2.editingFinished.connect(self.update_f02)
        self.ui.f0_pll1_tab2.editingFinished.connect(self.update_f0_tab2)
        self.ui.f0_pll2_tab2.editingFinished.connect(self.update_f02_tab2)
        #bw
        self.ui.bw_pll1.editingFinished.connect(self.update_bw)
        self.ui.bw_pll2.editingFinished.connect(self.update_bw2)
        self.ui.bw_pll1_tab2.editingFinished.connect(self.update_bw_tab2)
        self.ui.bw_pll2_tab2.editingFinished.connect(self.update_bw2_tab2)
        #alpha
        self.ui.alpha_pll1.editingFinished.connect(self.update_alpha)
        self.ui.alpha_pll2.editingFinished.connect(self.update_alpha2)
        self.ui.alpha_pll1_tab2.editingFinished.connect(self.update_alpha_tab2)
        self.ui.alpha_pll2_tab2.editingFinished.connect(self.update_alpha2_tab2)
        #order
        self.ui.order_pll1.editingFinished.connect(self.update_order)
        self.ui.order_pll2.editingFinished.connect(self.update_order2)
        self.ui.order_pll1_tab2.editingFinished.connect(self.update_order_tab2)
        self.ui.order_pll2_tab2.editingFinished.connect(self.update_order2_tab2)
    #--------------------------------------------------------
    def close_application(self):
        sys.exit()
        
    def about_pop_up(self):
        pop_up = QtWidgets.QMessageBox.about(self, 'About this program', 'Disclaimer: \n The design is strongly based on the redpitaya tutorials by [Anton Potocnik](http://antonpotocnik.com/?cat=29) \n The program\'s icon was designed using the Apache Licensed Open Source font, Roboto, by Google. (https://github.com/google/roboto/) \n \n Developers: \n - Felix Tebbenjohanns: tefelix@ethz.ch (hardware) \n - Dominik Windey: dwindey@ethz.ch (server program) \n - Clementina Saggini: clementina.saggini.18@ucl.ac.uk (GUI) \n - Markus Rademacher: m.rademacher.18@ucl.ac.uk (GUI)')
        
    def load_parameters(self):
        name = QtWidgets.QFileDialog.getOpenFileName(self, 'Open File')        
        with open(name[0], 'rb') as f: 
            self.rp.glob_param_values,self.rp.pll_param_values = pickle.load(f)
        self.rp.set_all_parameters()
        self.update_table_widget()
        
    def save_file(self):
        name = QtWidgets.QFileDialog.getSaveFileName(self, 'Save File')
        print(type(name[0]))
        if name[0][-4:] != '.pkl':
            with open(name[0]+'.pkl', 'wb') as f:
                pickle.dump([self.rp.glob_param_values,self.rp.pll_param_values],f)
        else:
            with open(name[0], 'wb') as f:
                pickle.dump([self.rp.glob_param_values,self.rp.pll_param_values],f)

        
        
    # Functions for Plls Table ---------------

            # order
    def update_order2_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(9).text(), self.ui.order_pll2_tab2.text(), 1)
            self.ui.order_pll2_tab2.setText(self.rp.read_parameter_user('order', pll=1))
            self.ui.order_pll2.setText(self.rp.read_parameter_user('order', pll=1))
        except IndexError:
            self.ui.order_pll2_tab2.setText(self.rp.read_parameter_user('order', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'You entered an incorrect value', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.order_pll2_tab2.setText(self.rp.read_parameter_user('order', pll=1))
            else:
                pass
    def update_order2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(9).text(), self.ui.order_pll2.text(), 1)
            self.ui.order_pll2.setText(self.rp.read_parameter_user('order', pll=1))
            self.ui.order_pll2_tab2.setText(self.rp.read_parameter_user('order', pll=1))
        except IndexError:
            self.ui.order_pll2.setText(self.rp.read_parameter_user('order', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.order_pll2.setText(self.rp.read_parameter_user('order', pll=1))
            else:
                pass
    def update_order_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(9).text(), self.ui.order_pll1_tab2.text(), 0)
            self.ui.order_pll1_tab2.setText(self.rp.read_parameter_user('order'))
            self.ui.order_pll1.setText(self.rp.read_parameter_user('order'))
        except IndexError:
            self.ui.order_pll1_tab2.setText(self.rp.read_parameter_user('order'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.order_pll1_tab2.setText(self.rp.read_parameter_user('order'))
            else:
                pass
    def update_order(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(9).text(), self.ui.order_pll1.text(), 0)
            self.ui.order_pll1.setText(self.rp.read_parameter_user('order'))
            self.ui.order_pll1_tab2.setText(self.rp.read_parameter_user('order'))
        except IndexError:
            self.ui.order_pll1.setText(self.rp.read_parameter_user('order'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.order_pll1.setText(self.rp.read_parameter_user('order'))
            else:
                pass

            # alpha
    def update_alpha2_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(8).text(), self.ui.alpha_pll2_tab2.text(), 1)
            self.ui.alpha_pll2_tab2.setText(self.rp.read_parameter_user('alpha', pll=1))
            self.ui.alpha_pll2.setText(self.rp.read_parameter_user('alpha', pll=1))
        except IndexError:
            self.ui.alpha_pll2_tab2.setText(self.rp.read_parameter_user('alpha', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.alpha_pll2_tab2.setText(self.rp.read_parameter_user('alpha', pll=1))
            else:
                pass
    def update_alpha2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(8).text(), self.ui.alpha_pll2.text(), 1)
            self.ui.alpha_pll2.setText(self.rp.read_parameter_user('alpha', pll=1))
            self.ui.alpha_pll2_tab2.setText(self.rp.read_parameter_user('alpha', pll=1))
        except IndexError:
            self.ui.alpha_pll2.setText(self.rp.read_parameter_user('alpha', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.alpha_pll2.setText(self.rp.read_parameter_user('alpha', pll=1))
            else:
                pass
    def update_alpha_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(8).text(), self.ui.alpha_pll1_tab2.text(), 0)
            self.ui.alpha_pll1_tab2.setText(self.rp.read_parameter_user('alpha'))
            self.ui.alpha_pll1.setText(self.rp.read_parameter_user('alpha'))
        except IndexError:
            self.ui.alpha_pll1_tab2.setText(self.rp.read_parameter_user('alpha'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.alpha_pll1_tab2.setText(self.rp.read_parameter_user('alpha'))
            else:
                pass
    def update_alpha(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(8).text(), self.ui.alpha_pll1.text(), 0)
            self.ui.alpha_pll1.setText(self.rp.read_parameter_user('alpha'))
            self.ui.alpha_pll1_tab2.setText(self.rp.read_parameter_user('alpha'))
        except IndexError:
            self.ui.alpha_pll1.setText(self.rp.read_parameter_user('alpha'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.alpha_pll1.setText(self.rp.read_parameter_user('alpha'))
            else:
                pass

            # bw
    def update_bw2_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(7).text(), self.ui.bw_pll2_tab2.text(), 1)
            self.ui.bw_pll2_tab2.setText(self.rp.read_parameter_user('bw', pll=1))
            self.ui.bw_pll2.setText(self.rp.read_parameter_user('bw', pll=1))
        except IndexError:
            self.ui.bw_pll2_tab2.setText(self.rp.read_parameter_user('bw', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.bw_pll2_tab2.setText(self.rp.read_parameter_user('bw', pll=1))
            else:
                pass
    def update_bw2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(7).text(), self.ui.bw_pll2.text(), 1)
            self.ui.bw_pll2.setText(self.rp.read_parameter_user('bw', pll=1))
            self.ui.bw_pll2_tab2.setText(self.rp.read_parameter_user('bw', pll=1))
        except IndexError:
            self.ui.bw_pll2.setText(self.rp.read_parameter_user('bw', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.bw_pll2.setText(self.rp.read_parameter_user('bw', pll=1))
            else:
                pass
    def update_bw_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(7).text(), self.ui.bw_pll1_tab2.text(), 0)
            self.ui.bw_pll1_tab2.setText(self.rp.read_parameter_user('bw'))
            self.ui.bw_pll1.setText(self.rp.read_parameter_user('bw'))
        except IndexError:
            self.ui.bw_pll1_tab2.setText(self.rp.read_parameter_user('bw'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.bw_pll1_tab2.setText(self.rp.read_parameter_user('bw'))
            else:
                pass
    def update_bw(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(7).text(), self.ui.bw_pll1.text(), 0)
            self.ui.bw_pll1.setText(self.rp.read_parameter_user('bw'))
            self.ui.bw_pll1_tab2.setText(self.rp.read_parameter_user('bw'))
        except IndexError:
            self.ui.bw_pll1.setText(self.rp.read_parameter_user('bw'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.bw_pll1.setText(self.rp.read_parameter_user('bw'))
            else:
                pass

            # f0
    def update_f02_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(6).text(), self.ui.f0_pll2_tab2.text(), 1)
            self.ui.f0_pll2_tab2.setText(self.rp.read_parameter_user('f0', pll=1))
            self.ui.f0_pll2.setText(self.rp.read_parameter_user('f0', pll=1))
        except IndexError:
            self.ui.f0_pll2_tab2.setText(self.rp.read_parameter_user('f0', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.f0_pll2_tab2.setText(self.rp.read_parameter_user('f0', pll=1))
            else:
                pass
    def update_f02(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(6).text(), self.ui.f0_pll2.text(), 1)
            self.ui.f0_pll2.setText(self.rp.read_parameter_user('f0', pll=1))
            self.ui.f0_pll2_tab2.setText(self.rp.read_parameter_user('f0', pll=1))
        except IndexError:
            self.ui.f0_pll2.setText(self.rp.read_parameter_user('f0', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.f0_pll2.setText(self.rp.read_parameter_user('f0', pll=1))
            else:
                pass
    def update_f0_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(6).text(), self.ui.f0_pll1_tab2.text(), 0)
            self.ui.f0_pll1_tab2.setText(self.rp.read_parameter_user('f0'))
            self.ui.f0_pll1.setText(self.rp.read_parameter_user('f0'))
        except IndexError:
            self.ui.f0_pll1_tab2.setText(self.rp.read_parameter_user('f0'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.f0_pll1_tab2.setText(self.rp.read_parameter_user('f0'))
            else:
                pass
    def update_f0(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(6).text(), self.ui.f0_pll1.text(), 0)
            self.ui.f0_pll1.setText(self.rp.read_parameter_user('f0'))
            self.ui.f0_pll1_tab2.setText(self.rp.read_parameter_user('f0'))
        except IndexError:
            self.ui.f0_pll1.setText(self.rp.read_parameter_user('f0'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.f0_pll1.setText(self.rp.read_parameter_user('f0'))
            else:
                pass

            # ki
    def update_ki2_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(5).text(), self.ui.ki_pll2_tab2.text(), 1)
            self.ui.ki_pll2_tab2.setText(self.rp.read_parameter_user('ki', pll=1))
            self.ui.ki_pll2.setText(self.rp.read_parameter_user('ki', pll=1))
        except IndexError:
            self.ui.ki_pll2_tab2.setText(self.rp.read_parameter_user('ki', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.ki_pll2_tab2.setText(self.rp.read_parameter_user('ki', pll=1))
            else:
                pass
    def update_ki2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(5).text(), self.ui.ki_pll2.text(), 1)
            self.ui.ki_pll2.setText(self.rp.read_parameter_user('ki', pll=1))
            self.ui.ki_pll2_tab2.setText(self.rp.read_parameter_user('ki', pll=1))
        except IndexError:
            self.ui.ki_pll2.setText(self.rp.read_parameter_user('ki', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.ki_pll2.setText(self.rp.read_parameter_user('ki', pll=1))
            else:
                pass
    def update_ki_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(5).text(), self.ui.ki_pll1_tab2.text(), 0)
            self.ui.ki_pll1_tab2.setText(self.rp.read_parameter_user('ki'))
            self.ui.ki_pll1.setText(self.rp.read_parameter_user('ki'))
        except IndexError:
            self.ui.ki_pll1_tab2.setText(self.rp.read_parameter_user('ki'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.ki_pll1_tab2.setText(self.rp.read_parameter_user('ki'))
            else:
                pass
    def update_ki(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(5).text(), self.ui.ki_pll1.text(), 0)
            self.ui.ki_pll1.setText(self.rp.read_parameter_user('ki'))
            self.ui.ki_pll1_tab2.setText(self.rp.read_parameter_user('ki'))
        except IndexError:
            self.ui.ki_pll1.setText(self.rp.read_parameter_user('ki'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.ki_pll1.setText(self.rp.read_parameter_user('ki'))
            else:
                pass

            # kp
    def update_kp2_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(4).text(), self.ui.kp_pll2_tab2.text(), 1)
            self.ui.kp_pll2_tab2.setText(self.rp.read_parameter_user('kp', pll=1))
            self.ui.kp_pll2.setText(self.rp.read_parameter_user('kp', pll=1))
        except IndexError:
            self.ui.kp_pll2_tab2.setText(self.rp.read_parameter_user('kp', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.kp_pll2_tab2.setText(self.rp.read_parameter_user('kp', pll=1))
            else:
                pass
    def update_kp2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(4).text(), self.ui.kp_pll2.text(), 1)
            self.ui.kp_pll2.setText(self.rp.read_parameter_user('kp', pll=1))
            self.ui.kp_pll2_tab2.setText(self.rp.read_parameter_user('kp', pll=1))
        except IndexError:
            self.ui.kp_pll2.setText(self.rp.read_parameter_user('kp', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.kp_pll2.setText(self.rp.read_parameter_user('kp', pll=1))
            else:
                pass
    def update_kp_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(4).text(), self.ui.kp_pll1_tab2.text(), 0)
            self.ui.kp_pll1_tab2.setText(self.rp.read_parameter_user('kp'))
            self.ui.kp_pll1.setText(self.rp.read_parameter_user('kp'))
        except IndexError:
            self.ui.kp_pll1_tab2.setText(self.rp.read_parameter_user('kp'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.kp_pll1_tab2.setText(self.rp.read_parameter_user('kp'))
            else:
                pass
    def update_kp(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(4).text(), self.ui.kp_pll1.text(), 0)
            self.ui.kp_pll1.setText(self.rp.read_parameter_user('kp'))
            self.ui.kp_pll1_tab2.setText(self.rp.read_parameter_user('kp'))
        except IndexError:
            self.ui.kp_pll1.setText(self.rp.read_parameter_user('kp'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.kp_pll1.setText(self.rp.read_parameter_user('kp'))
            else:
                pass
            
            # phi
    def update_phi2_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(3).text(), self.ui.phi_pll2_tab2.text(), 1)
            self.ui.phi_pll2_tab2.setText(self.rp.read_parameter_user('phi', pll=1))
            self.ui.phi_pll2.setText(self.rp.read_parameter_user('phi', pll=1))
        except IndexError:
            self.ui.phi_pll2_tab2.setText(self.rp.read_parameter_user('phi', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.phi_pll2_tab2.setText(self.rp.read_parameter_user('phi', pll=1))
            else:
                pass
    def update_phi2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(3).text(), self.ui.phi_pll2.text(), 1)
            self.ui.phi_pll2.setText(self.rp.read_parameter_user('phi', pll=1))
            self.ui.phi_pll2_tab2.setText(self.rp.read_parameter_user('phi', pll=1))
        except IndexError:
            self.ui.phi_pll2.setText(self.rp.read_parameter_user('phi', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.phi_pll2.setText(self.rp.read_parameter_user('phi', pll=1))
            else:
                pass
    def update_phi_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(3).text(), self.ui.phi_pll1_tab2.text(), 0)
            self.ui.phi_pll1_tab2.setText(self.rp.read_parameter_user('phi'))
            self.ui.phi_pll1.setText(self.rp.read_parameter_user('phi'))
        except IndexError:
            self.ui.phi_pll1_tab2.setText(self.rp.read_parameter_user('phi'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.phi_pll1_tab2.setText(self.rp.read_parameter_user('phi'))
            else:
                pass
    def update_phi(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(3).text(), self.ui.phi_pll1.text(), 0)
            self.ui.phi_pll1.setText(self.rp.read_parameter_user('phi'))
            self.ui.phi_pll1_tab2.setText(self.rp.read_parameter_user('phi'))
        except IndexError:
            self.ui.phi_pll1.setText(self.rp.read_parameter_user('phi'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.phi_pll1.setText(self.rp.read_parameter_user('phi'))
            else:
                pass
            
            # a
    def update_a2_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(2).text(), self.ui.a_pll2_tab2.text(), 1)
            self.ui.a_pll2_tab2.setText(self.rp.read_parameter_user('a', pll=1))
            self.ui.a_pll2.setText(self.rp.read_parameter_user('a', pll=1))
        except IndexError:
            self.ui.a_pll2_tab2.setText(self.rp.read_parameter_user('a', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.a_pll2_tab2.setText(self.rp.read_parameter_user('a', pll=1))
            else:
                pass
    def update_a2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(2).text(), self.ui.a_pll2.text(), 1)
            self.ui.a_pll2.setText(self.rp.read_parameter_user('a', pll=1))
            self.ui.a_pll2_tab2.setText(self.rp.read_parameter_user('a', pll=1))
        except IndexError:
            self.ui.a_pll2.setText(self.rp.read_parameter_user('a', pll=1))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.a_pll2.setText(self.rp.read_parameter_user('a', pll=1))
            else:
                pass
    def update_a_tab2(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(2).text(), self.ui.a_pll1_tab2.text(), 0)
            self.ui.a_pll1_tab2.setText(self.rp.read_parameter_user('a'))
            self.ui.a_pll1.setText(self.rp.read_parameter_user('a'))
        except IndexError:
            self.ui.a_pll1_tab2.setText(self.rp.read_parameter_user('a'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.a_pll1_tab2.setText(self.rp.read_parameter_user('a'))
            else:
                pass
    def update_a(self):
        try:
            self.updateParam(self.ui.tableWidgetPlls.verticalHeaderItem(2).text(), self.ui.a_pll1.text(), 0)
            self.ui.a_pll1.setText(self.rp.read_parameter_user('a'))
            self.ui.a_pll1_tab2.setText(self.rp.read_parameter_user('a'))
        except IndexError:
            self.ui.a_pll1.setText(self.rp.read_parameter_user('a'))
        except ValueError:
            choice = QtWidgets.QMessageBox.question(self, 'Message', 'The value entered is invalid', QtWidgets.QMessageBox.Ok)
            if choice == QtWidgets.QMessageBox.Ok:
                self.ui.a_pll1.setText(self.rp.read_parameter_user('a'))
            else:
                pass
    #---------------------------------------------------------------------#
            
    #does it work?
    def update_ext_pins_p(self):
        self.rp.read_parameter_user('ext_pins_p') 
        print('ext_pins_p')
        
    # Functions for Check Boxes
    
        # 2nd_harm
    def second_harm_pll1(self, int):
        if self.ui.second_harm_pll1.isChecked():
            self.ui.second_harm_pll1_tab2.setChecked(True)
        else:
            self.ui.second_harm_pll1_tab2.setChecked(False)
            
        self.ui.bw_pll1.setText(self.rp.read_parameter_user('bw'))
        self.ui.bw_pll1_tab2.setText(self.rp.read_parameter_user('bw'))
        self.ui.f0_pll1.setText(self.rp.read_parameter_user('f0'))
        self.ui.f0_pll1_tab2.setText(self.rp.read_parameter_user('f0'))
        
    def second_harm_pll1_tab2(self, int):
        if self.ui.second_harm_pll1_tab2.isChecked():
            self.ui.second_harm_pll1.setChecked(True)
        else:
            self.ui.second_harm_pll1.setChecked(False)
    def second_harm_pll2(self, int):
        if self.ui.second_harm_pll2.isChecked():
            self.ui.second_harm_pll2_tab2.setChecked(True)
        else:
            self.ui.second_harm_pll2_tab2.setChecked(False)

        self.ui.bw_pll2.setText(self.rp.read_parameter_user('bw'))
        self.ui.bw_pll2_tab2.setText(self.rp.read_parameter_user('bw'))
        self.ui.f0_pll2.setText(self.rp.read_parameter_user('f0'))
        self.ui.f0_pll2_tab2.setText(self.rp.read_parameter_user('f0'))
    def second_harm_pll2_tab2(self, int):
        if self.ui.second_harm_pll2_tab2.isChecked():
            self.ui.second_harm_pll2.setChecked(True)
        else:
            self.ui.second_harm_pll2.setChecked(False)

        # pid_en
    def pid_en_pll1(self, int):
        if self.ui.pid_en_pll1.isChecked():
            self.ui.pid_en_pll1_tab2.setChecked(True)
        else:
            self.ui.pid_en_pll1_tab2.setChecked(False)
    def pid_en_pll1_tab2(self, int):
        if self.ui.pid_en_pll1_tab2.isChecked():
            self.ui.pid_en_pll1.setChecked(True)
        else:
            self.ui.pid_en_pll1.setChecked(False)
    def pid_en_pll2(self, int):
        if self.ui.pid_en_pll2.isChecked():
            self.ui.pid_en_pll2_tab2.setChecked(True)
        else:
            self.ui.pid_en_pll2_tab2.setChecked(False)
    def pid_en_pll2_tab2(self, int):
        if self.ui.pid_en_pll2_tab2.isChecked():
            self.ui.pid_en_pll2.setChecked(True)
        else:
            self.ui.pid_en_pll2.setChecked(False)
            
       # Functions for output in table Global
    def update_output_1(self, param):
        self.rp.update_parameter_user('output_1',param)
        print('output_1')
        print(param)

    def update_output_2(self, param):
        self.rp.update_parameter_user('output_2', param)
        print('output_2')
        print(param)


    def updateParam(self, param, val, pll):
        print(param)
        self.rp.update_parameter_user(param, val, pll)
        self.rp.get_all_parameters()
       
    def update_table_widget(self):
       # FOR TAB 1
        self.ui.a_pll1.setText(self.rp.read_parameter_user('a'))
        self.ui.a_pll2.setText(self.rp.read_parameter_user('a', pll=1))
        self.ui.phi_pll1.setText(self.rp.read_parameter_user('phi'))
        self.ui.phi_pll2.setText(self.rp.read_parameter_user('phi', pll=1))
        self.ui.kp_pll1.setText(self.rp.read_parameter_user('kp'))
        self.ui.kp_pll2.setText(self.rp.read_parameter_user('kp', pll=1))
        self.ui.ki_pll1.setText(self.rp.read_parameter_user('ki'))
        self.ui.ki_pll2.setText(self.rp.read_parameter_user('ki', pll=1))
        self.ui.f0_pll1.setText(self.rp.read_parameter_user('f0'))
        self.ui.f0_pll2.setText(self.rp.read_parameter_user('f0', pll=1))
        self.ui.bw_pll1.setText(self.rp.read_parameter_user('bw'))
        self.ui.bw_pll2.setText(self.rp.read_parameter_user('bw', pll=1))
        self.ui.alpha_pll1.setText(self.rp.read_parameter_user('alpha'))
        self.ui.alpha_pll2.setText(self.rp.read_parameter_user('alpha', pll=1))
        self.ui.order_pll1.setText(self.rp.read_parameter_user('order'))
        self.ui.order_pll2.setText(self.rp.read_parameter_user('order', pll=1))
        self.ui.output_1.setCurrentText(self.rp.read_parameter_user('output_1'))
        self.ui.output_2.setCurrentText(self.rp.read_parameter_user('output_2'))
       # FOR TAB 2
        # PLL 1
        self.ui.alpha_pll1_tab2.setText(self.rp.read_parameter_user('alpha'))
        self.ui.alpha_pll1_tab2.adjustSize()
        self.ui.order_pll1_tab2.setText(self.rp.read_parameter_user('order'))
        self.ui.kp_pll1_tab2.setText(self.rp.read_parameter_user('kp'))
        self.ui.ki_pll1_tab2.setText(self.rp.read_parameter_user('ki'))
        self.ui.bw_pll1_tab2.setText(self.rp.read_parameter_user('bw'))
        self.ui.bw_pll1_tab2.adjustSize()
        self.ui.f0_pll1_tab2.setText(self.rp.read_parameter_user('f0'))
        self.ui.a_pll1_tab2.setText(self.rp.read_parameter_user('a'))
        self.ui.phi_pll1_tab2.setText(self.rp.read_parameter_user('phi'))
        # PLL 2
        self.ui.alpha_pll2_tab2.setText(self.rp.read_parameter_user('alpha', pll=1))
        self.ui.alpha_pll2_tab2.adjustSize()
        self.ui.order_pll2_tab2.setText(self.rp.read_parameter_user('order', pll=1))
        self.ui.kp_pll2_tab2.setText(self.rp.read_parameter_user('kp', pll=1))
        self.ui.ki_pll2_tab2.setText(self.rp.read_parameter_user('ki', pll=1))
        self.ui.bw_pll2_tab2.setText(self.rp.read_parameter_user('bw', pll=1))
        self.ui.bw_pll2_tab2.adjustSize()
        self.ui.f0_pll2_tab2.setText(self.rp.read_parameter_user('f0', pll=1))
        self.ui.a_pll2_tab2.setText(self.rp.read_parameter_user('a', pll=1))
        self.ui.a_pll2_tab2.adjustSize()
        self.ui.phi_pll2_tab2.setText(self.rp.read_parameter_user('phi', pll=1))
                
if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    window = GUI(hostname=HOSTNAME, n_pll=2)
    sys.exit(app.exec_())



