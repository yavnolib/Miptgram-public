# x, y, approx, filename
from multiprocessing import Process, Queue
import uuid
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
import seaborn as sns
from scipy.optimize import curve_fit

matplotlib.use('Agg')


class Graph:
    @staticmethod
    def exponent(x, a, b):
        return a * np.exp(b*x)

    @staticmethod
    def sig_MNK(x_nn, y_nn, k_n):
        sqyn = [i**2 for i in y_nn]
        m_sqyn = sum(sqyn) / len(sqyn)
        myn = sum(y_nn) / len(y_nn)
        sq_myn = myn**2
        sqxn = [i**2 for i in x_nn]
        m_sqxn = sum(sqxn) / len(sqxn)
        mxn = sum(x_nn) / len(x_nn)
        sq_mxn = mxn**2
        sig_n = 1 / np.sqrt(len(y_nn)) * np.sqrt((m_sqyn - sq_myn) / (m_sqxn - sq_mxn) -
                                                 (k_n**2))
        return sig_n

    @staticmethod
    def MNK(x, y):
        A = np.vstack([x, np.ones(len(x))]).T
        k, b = np.linalg.lstsq(A, y, rcond=None)[0]
        sig_k = Graph.sig_MNK(x, y, k)
        return [k, b, sig_k]

    @staticmethod
    def save_graph(queue, x, y, approx='no', label='Значения',
                   xlabel='x', ylabel='y', x_scale=0, y_scale=0, use_dark=1):
        try:
            if use_dark:
                sns.set(style='darkgrid', font_scale=1.3, palette='Set2')
            else:
                sns.set(style='whitegrid', font_scale=1.3, palette='Set2')

            filename = uuid.uuid4().hex + '.png'
            fig, ax = plt.subplots(figsize=(8, 6))
            if approx != 'exp':
                ax.plot(x, y, 'D', label=label)

            if approx == 'linear':
                k, b, sig_k = Graph.MNK(x, y)
                st = '+' + str(round(b, 2)) if b >= 0 else '-' + \
                    str(abs(round(b, 2)))
                ax.plot(x, k*x + b, '-',
                        label=f'y={round(k, 2)}x{st}, σ={round(sig_k, 2)}')
            # Добавить погрешности в нелинейный случай
            elif approx.isdigit():
                z = np.polyfit(x, y, int(approx))
                f = np.poly1d(z)
                ax.plot(x, f(x), '-', label=f'Полином степени {approx}')
            # добавить обработку квадратичной зависимости
            elif approx == 'exp':
                params, cov = curve_fit(Graph.exponent, x, y)
                a, b = params

                ax.plot(np.exp(b*x), y, 'D', label=label)
                k, d, sig_k = Graph.MNK(np.exp(x * b), y)
                st = '+' + str(round(d, 2)) if d >= 0 else '-' + \
                    str(abs(round(d, 2)))
                ax.plot(np.exp(x * b), k*np.exp(b*x) + d,
                        '-', label=f'y={round(k, 2)}x{st}')
                plt.xlabel('e^(bx)')
            if x_scale:
                ax.set_xscale('log')
            if y_scale:
                ax.set_yscale('log')

            ax.minorticks_on()

            if use_dark:
                ax.grid(which='minor', color='white',
                        linewidth=1)
            else:
                ax.grid(which='minor', color='black',
                        linewidth=1)
            if approx != 'exp':
                plt.xlabel(xlabel)
            plt.ylabel(ylabel)
            plt.legend()
            plt.savefig(filename)
            queue.put(filename)
        except:
            try:
                queue.put(-1)
            except:
                pass


def use_graph(x, y, approx='no', label='Значения',
              xlabel='x', ylabel='y', x_scale=0, y_scale=0, use_dark=1):
    approx = 'no' if approx == 'None' else approx
    label = 'Значения' if label == 'None' else label
    xlabel = 'x' if xlabel == 'None' else xlabel
    ylabel = 'y' if ylabel == 'None' else ylabel
    x_scale = 0 if x_scale == 'None' else x_scale
    y_scale = 0 if y_scale == 'None' else y_scale
    use_dark = 1 if use_dark == 'None' else use_dark
    print(approx, label, xlabel, ylabel, x_scale, y_scale, use_dark)
    print(type(xlabel), xlabel == 'None')
    q = Queue()
    p = Process(target=Graph.save_graph, args=(q, x, y), kwargs={'approx': approx, 'label': label,
                                                                 'xlabel': xlabel, 'ylabel': ylabel,
                                                                 'x_scale': x_scale, 'y_scale': y_scale, 'use_dark': use_dark})
    p.start()
    p.join()
    return q.get()


if __name__ == '__main__':
    print(use_graph(np.arange(5), 5*np.arange(5), approx='linear', label='Хуйня'))
    # prints "[42, None, 'hello']"

# Graph.save_graph(np.arange(20), 3*np.arange(20), approx='linear', label='Значения',
    #    xlabel='x', ylabel='y', x_scale=0, y_scale=0, use_dark=1)
